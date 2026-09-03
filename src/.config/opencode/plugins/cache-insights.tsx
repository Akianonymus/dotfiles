import { Plugin } from "@opencode-ai/plugin/tui"
import { createMemo, Show, For, Match, Switch, createSignal } from "solid-js"
import { useTerminalDimensions } from "@opentui/solid"
import type {
  SessionMessageInfo,
  TokenUsageInfo,
  ModelInfo,
  McpServer,
} from "@opencode-ai/client"

type AssistantWithTokens = Extract<SessionMessageInfo, { type: "assistant" }> & {
  tokens: TokenUsageInfo
}

function estimateTokens(text: string): number {
  return Math.ceil(text.length / 4)
}

function messageText(m: SessionMessageInfo): string {
  switch (m.type) {
    case "system":
    case "user":
    case "skill":
    case "synthetic":
      return m.text
    case "shell":
      return m.output ? `${m.command}\n${m.output.output}` : m.command
    case "compaction":
      return `${m.summary}\n${m.recent}`
    case "assistant":
      return JSON.stringify(m.content)
    case "agent-switched":
      return m.agent
    case "model-switched":
      return m.model.id
    case "location-switched":
      return m.location.directory
  }
}

function lastAssistantWithUsage(
  messages: readonly SessionMessageInfo[],
  boundary?: string,
): AssistantWithTokens | undefined {
  const boundaryIndex = boundary ? messages.findIndex((m) => m.id === boundary) : -1
  if (boundary && boundaryIndex === -1) return undefined
  const end = boundaryIndex === -1 ? messages.length : boundaryIndex
  const compactionIndex = messages.findLastIndex(
    (m, index) => m.type === "compaction" && m.status === "completed" && index < end,
  )
  return messages.findLast(
    (m, index): m is AssistantWithTokens =>
      m.type === "assistant" && m.tokens !== undefined && index > compactionIndex && index < end,
  )
}

function contextUsage(
  messages: readonly SessionMessageInfo[],
  models: readonly ModelInfo[] | undefined,
  boundary?: string,
): { tokens: number; percent: number | undefined } | undefined {
  const last = lastAssistantWithUsage(messages, boundary)
  if (!last) return
  const tokens =
    last.tokens.input + last.tokens.output + last.tokens.reasoning + last.tokens.cache.read + last.tokens.cache.write
  if (tokens <= 0) return
  const model = models?.find((m) => m.providerID === last.model.providerID && m.id === last.model.id)
  return {
    tokens,
    percent: model?.limit?.context ? Math.round((tokens / model.limit.context) * 100) : undefined,
  }
}

async function showContextBreakdown(ctx: Plugin.Context, sessionID: string) {
  const messages = ctx.data.session.message.list(sessionID)
  const session = ctx.data.session.get(sessionID)
  const boundary = session?.revert?.messageID
  const last = lastAssistantWithUsage(messages, boundary)
  const models = ctx.data.location.model.list(session?.location)
  const model = last
    ? models?.find((m) => m.providerID === last.model.providerID && m.id === last.model.id)
    : undefined
  const limit = model?.limit?.context
  const total = last
    ? last.tokens.input + last.tokens.output + last.tokens.reasoning + last.tokens.cache.read + last.tokens.cache.write
    : 0

  let assembled: SessionMessageInfo[] = []
  try {
    assembled = await ctx.client.session.context({ sessionID })
  } catch {
    assembled = []
  }
  const source: SessionMessageInfo[] = assembled.length > 0 ? assembled : messages

  const counts = { system: 0, user: 0, assistant: 0, other: 0 }
  let systemTokens = 0
  let toolTokens = 0
  let conversationTokens = 0
  let otherTokens = 0
  for (const m of source) {
    const text = messageText(m)
    switch (m.type) {
      case "system":
        counts.system++
        systemTokens += estimateTokens(text.slice(0, 8000))
        break
      case "user":
        counts.user++
        conversationTokens += estimateTokens(text.slice(0, 4000))
        break
      case "assistant":
        counts.assistant++
        conversationTokens += estimateTokens(text.slice(0, 4000))
        break
      case "skill":
      case "synthetic":
      case "shell":
      case "compaction":
      case "agent-switched":
      case "model-switched":
      case "location-switched":
        counts.other++
        otherTokens += estimateTokens(text.slice(0, 1000))
        break
    }
  }
  // System prompt is the small initial OpenCode instruction, not the cached prefix.
  // If still 0 here, derive from the first system message, capped to a sane prompt size.
  if (systemTokens === 0 && source.length > 0) {
    const firstSystem = source.find((m) => m.type === "system")
    if (firstSystem && firstSystem.type === "system") {
      const estimated = estimateTokens(firstSystem.text.slice(0, 4000))
      if (estimated > 0 && estimated < 5000) systemTokens = estimated
    }
  }

  const cacheRead = last?.tokens.cache.read ?? 0
  const cacheWrite = last?.tokens.cache.write ?? 0
  const input = last?.tokens.input ?? 0
  const output = last?.tokens.output ?? 0
  const reasoning = last?.tokens.reasoning ?? 0
  const hit = cacheRead + input > 0 ? cacheRead / (cacheRead + input) : 0
  const coverage = total > 0 ? (cacheRead / total) * 100 : 0
  const messageTotal = source.length

  const Detail = () => {
    const dims = useTerminalDimensions()
    const maxH = () => Math.min(28, Math.max(12, dims().height - 10))
    return (
      <box flexDirection="column" gap={1} paddingLeft={1} paddingRight={1} paddingBottom={1}>
        <box justifyContent="center">
          <text>
            <b>Context Breakdown — Scale</b>
          </text>
        </box>
        <scrollbox flexGrow={1} maxHeight={maxH()}>
          <box flexDirection="column" gap={1} paddingLeft={1}>
            <box flexDirection="column" gap={0}>
              <text>{`Session: ${session?.id?.slice(0, 8) ?? sessionID.slice(0, 8)} • ${model?.id ?? last?.model.id ?? "—"}`}</text>
              <text>{`Limit: ${limit ? limit.toLocaleString() : "—"} • Used: ${total ? total.toLocaleString() : "—"}${limit && total ? ` (${Math.round(total / limit * 100)}%)` : ""}`}</text>
              <text>{`Messages: ${messageTotal} (sys:${counts.system} user:${counts.user} asst:${counts.assistant} other:${counts.other})`}</text>
            </box>
            <box flexDirection="column" gap={0}>
              <text>
                <b>By category (est.)</b>
              </text>
              <box flexDirection="column" gap={0} paddingLeft={2}>
                <text>{`System:        ${(systemTokens + otherTokens).toLocaleString().padStart(6)} tok  (${total ? (((systemTokens + otherTokens) / total) * 100).toFixed(1).padStart(4) : "0.0"}%)`}</text>
                <text>{`Tools:         ${toolTokens.toLocaleString().padStart(6)} tok  (${total ? ((toolTokens / total) * 100).toFixed(1).padStart(4) : "0.0"}%)`}</text>
                <text>{`Conversation:  ${conversationTokens.toLocaleString().padStart(6)} tok  (${total ? ((conversationTokens / total) * 100).toFixed(1).padStart(4) : "0.0"}%)`}</text>
                <box height={1} />
                <text>{`Input:         ${input.toLocaleString().padStart(6)} tok`}</text>
                <text>{`Cache read:    ${cacheRead.toLocaleString().padStart(6)} tok`}</text>
                <text>{`Cache write:   ${cacheWrite.toLocaleString().padStart(6)} tok`}</text>
                <text>{`Output:        ${output.toLocaleString().padStart(6)} tok`}</text>
                <text>{`Reasoning:     ${reasoning.toLocaleString().padStart(6)} tok`}</text>
              </box>
            </box>
            <box flexDirection="column" gap={0}>
              <text>
                <b>Scale</b>
              </text>
              <box flexDirection="column" gap={0} paddingLeft={2}>
                <text>{`Context used: ${total ? `${Math.round(total / 1000)}K / ${limit ? Math.round(limit / 1000) : "?"}K` : "—"}`}</text>
                <text>{`Cache hit: ${(hit * 100).toFixed(1)}% • coverage ${coverage.toFixed(1)}%`}</text>
              </box>
            </box>
            <box flexDirection="column" gap={0} paddingTop={1}>
              <text>Estimates via characters/4; system/conversation split from messages.</text>
              <text>Tools count from provider definitions (approx).</text>
            </box>
          </box>
        </scrollbox>
      </box>
    )
  }
  ctx.ui.dialog.show(() => <Detail />)
  ctx.ui.dialog.set({ size: "large", centered: true })
}

async function showTabsBrowser(ctx: Plugin.Context) {
  type TabEntry = {
    sessionID: string
    title: string | undefined
    active: boolean
    busy: boolean
    attention: boolean
  }
  const tabs = ctx.ui.tabs.list()
  const source: TabEntry[] =
    tabs.length > 0
      ? tabs.map((t) => ({
          sessionID: t.sessionID,
          title: t.title,
          active: t.active,
          busy: t.busy,
          attention: t.attention,
        }))
      : ctx.data.session.list().map((s) => ({
          sessionID: s.id,
          title: s.title,
          active: false,
          busy: false,
          attention: false,
        }))
  if (source.length === 0) return
  const options = source.map((t) => {
    const flags = [t.active ? "active" : "", t.busy ? "busy" : "", t.attention ? "attention" : ""].filter(
      Boolean,
    )
    return {
      title: t.title ?? t.sessionID.slice(0, 8),
      value: t.sessionID,
      description: flags.length > 0 ? flags.join(" • ") : undefined,
      category: t.active ? "Active" : "Open",
    }
  })
  const current = tabs.find((t) => t.active)?.sessionID
  const picked = await ctx.ui.dialog.select({ title: "Open Tabs", options, current })
  if (picked === undefined) return
  if (!ctx.ui.tabs.open(picked)) ctx.ui.router.navigate({ type: "session", sessionID: picked })
}

function CompositeSidebar(props: { ctx: Plugin.Context; sessionID: string }) {
  const ctx = props.ctx

  // Context block (same as opencode.sidebar.context)
  const contextState = createMemo(() => {
    const msgs = ctx.data.session.message.list(props.sessionID)
    const session = ctx.data.session.get(props.sessionID)
    const models = ctx.data.location.model.list(session?.location)
    return {
      usage: contextUsage(msgs, models, session?.revert?.messageID),
      cost: ctx.data.session.cost(props.sessionID),
    }
  })

  // Cache hit rate
  const cacheState = createMemo(() => {
    const msgs = ctx.data.session.message.list(props.sessionID)
    const session = ctx.data.session.get(props.sessionID)
    const last = lastAssistantWithUsage(msgs, session?.revert?.messageID)
    if (!last?.tokens) return
    const t = last.tokens
    const total = t.input + t.output + t.reasoning + t.cache.read + t.cache.write
    if (total <= 0) return
    const models = ctx.data.location.model.list(session?.location)
    const model = models?.find((m) => m.providerID === last.model.providerID && m.id === last.model.id)
    const limit = model?.limit?.context
    const percent = limit ? Math.round((total / limit) * 100) : undefined
    const hit = t.cache.read + t.input > 0 ? t.cache.read / (t.cache.read + t.input) : 0
    return { total, hit, limit, percent, model }
  })

  // MCP block
  const mcpList = createMemo(() => {
    const session = ctx.data.session.get(props.sessionID)
    return ctx.data.location.mcp.server.list(session?.location) ?? []
  })

  const [contextHover, setContextHover] = createSignal(false)
  const openContextDetails = () => showContextBreakdown(ctx, props.sessionID)

  return (
    <box flexDirection="column" gap={0}>
      {/* Context with info icon */}
      <Show when={contextState().usage || contextState().cost > 0}>
        <box flexDirection="column">
          <box flexDirection="row" gap={1}>
            <text>
              <b>Context</b>
            </text>
            <box
              paddingLeft={1}
              paddingRight={1}
              onMouseEnter={() => setContextHover(true)}
              onMouseLeave={() => setContextHover(false)}
              onMouseUp={() => setTimeout(openContextDetails, 0)}
            >
              <text fg={contextHover() ? ctx.theme.text.default : ctx.theme.text.muted}>ⓘ</text>
            </box>
          </box>
          <Show when={contextState().usage}>
            {(u) => (
              <>
                <text>{`${u().tokens.toLocaleString()} tokens`}</text>
                <Show when={u().percent !== undefined}>
                  <text>{`${u().percent}% used`}</text>
                </Show>
              </>
            )}
          </Show>
          <Show when={contextState().cost > 0}>
            <text>{`$${contextState().cost.toFixed(4)} spent`}</text>
          </Show>
        </box>
      </Show>

      {/* Cache hit rate just below Context */}
      <Show when={cacheState()}>
        {(s) => (
          <box flexDirection="column" paddingBottom={1}>
            <text>{`Cache Hit: ${(s().hit * 100).toFixed(1)}%`}</text>
          </box>
        )}
      </Show>

      {/* MCP - below Cache Insights */}
      <Show when={mcpList().length > 0}>
        <McpView ctx={ctx} sessionID={props.sessionID} />
      </Show>
    </box>
  )
}

function McpView(props: { ctx: Plugin.Context; sessionID: string }) {
  const [open, setOpen] = createSignal(true)
  const session = createMemo(() => props.ctx.data.session.get(props.sessionID))
  const list = createMemo(() => props.ctx.data.location.mcp.server.list(session()?.location) ?? [])
  const on = createMemo(() => list().filter((i) => i.status.status === "connected").length)
  const bad = createMemo(() =>
    list().filter((i) => i.status.status === "failed" || i.status.status === "needs_auth").length,
  )
  return (
    <Show when={list().length > 0}>
      <box flexDirection="column">
        <box flexDirection="row" gap={1} onMouseDown={() => list().length > 2 && setOpen((x) => !x)}>
          <Show when={list().length > 2}>
            <text>{open() ? "▼" : "▶"}</text>
          </Show>
          <text>
            <b>MCP</b>
            <Show when={!open()}>
              <text>{` (${on()} active${bad() > 0 ? `, ${bad()} error${bad() > 1 ? "s" : ""}` : ""})`}</text>
            </Show>
          </text>
        </box>
        <Show when={list().length <= 2 || open()}>
          <For each={list()}>
            {(item: McpServer) => (
              <box flexDirection="row" gap={1}>
                <text>•</text>
                <text>
                  <b>{item.name}</b>
                </text>
                <text>
                  <Switch fallback={item.status.status}>
                    <Match when={item.status.status === "connected"}>Connected</Match>
                    <Match when={item.status.status === "pending"}>Connecting</Match>
                    <Match when={item.status.status === "failed"}>Error</Match>
                    <Match when={item.status.status === "disabled"}>Disabled</Match>
                    <Match when={item.status.status === "needs_auth"}>Sign in</Match>
                  </Switch>
                </text>
              </box>
            )}
          </For>
        </Show>
      </box>
    </Show>
  )
}

export default Plugin.define({
  id: "cache-insights",
  setup(ctx) {
    const disposeSidebar = ctx.ui.slot({
      replace: "sidebar.content",
      render: (input) => <CompositeSidebar ctx={ctx} sessionID={input.sessionID} />,
    })
    // palette command via hidden app slot to ensure Keymap.Provider is available (avoids hot-reload Provider missing)
    const disposePalette = ctx.ui.slot({
      append: "app",
      render: () => {
        ctx.keymap.layer(() => ({
          mode: "global",
          priority: 10,
          commands: [
            {
              id: "cache-insights.context-breakdown",
              title: "Context Breakdown",
              group: "Cache Insights",
              palette: true,
              enabled: true,
              run: async () => {
                const route = ctx.ui.router.current()
                const sessionID =
                  route.type === "session" ? route.sessionID : ctx.data.session.list()[0]?.id
                if (sessionID) await showContextBreakdown(ctx, sessionID)
              },
            },
            {
              id: "cache-insights.tabs-browser",
              title: "Tabs",
              group: "Navigation",
              palette: true,
              enabled: true,
              run: async () => {
                await showTabsBrowser(ctx)
              },
            },
          ],
          bindings: ["cache-insights.context-breakdown"],
        }))
        return null
      },
    })
    return () => {
      disposeSidebar()
      disposePalette()
    }
  },
})
