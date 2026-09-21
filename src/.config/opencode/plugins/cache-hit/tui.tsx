import { Plugin } from "@opencode/plugin/tui"
import { createMemo, Show, For } from "solid-js"

export default Plugin.define({
  id: "cache-hit",
  setup(ctx) {
    // Host slots are coarse (sidebar.content / sidebar.footer), so placing
    // the line between Context and MCP requires taking over sidebar.content
    // and replicating those two blocks in order.
    return ctx.ui.slot({
      replace: "sidebar.content",
      render: (input) => {
        const contextState = createMemo(() => {
          const session = ctx.data.session.get(input.sessionID)
          const messages = ctx.data.session.message.list(input.sessionID)
          const boundary = (session as { revert?: { messageID?: string } } | undefined)?.revert?.messageID

          const end = boundary ? messages.findIndex((m) => m.id === boundary) : -1
          const list = end === -1 ? messages : messages.slice(0, end)
          const lastCompaction = list.findLastIndex(
            (m) => m.type === "compaction" && (m as { status?: string }).status === "completed",
          )
          const last = list.findLast(
            (m, i) => m.type === "assistant" && (m as { tokens?: unknown }).tokens !== undefined && i > lastCompaction,
          ) as
            | {
                tokens: { input: number; output: number; reasoning: number; cache: { read: number; write: number } }
                model: { providerID: string; id: string }
              }
            | undefined

          if (!last?.tokens) return undefined
          const t = last.tokens
          const total = t.input + t.output + t.reasoning + t.cache.read + t.cache.write
          if (total <= 0) return undefined

          const models = ctx.data.location.model.list(session?.location as never)
          const model = models?.find((m) => m.providerID === last.model.providerID && m.id === last.model.id)
          const limit = model?.limit?.context as number | undefined
          const percent = limit ? Math.round((total / limit) * 100) : undefined
          const denom = t.cache.read + t.input
          const hit = denom > 0 ? (t.cache.read / denom) * 100 : undefined
          const cost = ctx.data.session.cost(input.sessionID)

          return { total, percent, hit, cost }
        })

        const mcpList = createMemo(() => {
          const session = ctx.data.session.get(input.sessionID)
          return ctx.data.location.mcp.server.list(session?.location as never) ?? []
        })

        return (
          <box flexDirection="column" gap={1}>
            <Show when={contextState()}>
              {(s) => (
                <box flexDirection="column">
                  <text>
                    <b>Context</b>
                  </text>
                  <text>{`${s().total.toLocaleString()} tokens`}</text>
                  <Show when={s().percent !== undefined}>
                    <text>{`${s().percent}% used`}</text>
                  </Show>
                  <Show when={s().cost > 0}>
                    <text>{`$${s().cost.toFixed(2)} spent`}</text>
                  </Show>
                </box>
              )}
            </Show>

            <Show when={contextState()?.hit !== undefined}>
              <text>{`Cache Hit: ${contextState()!.hit!.toFixed(0)}%`}</text>
            </Show>

            <Show when={mcpList().length > 0}>
              <box flexDirection="column">
                <text>
                  <b>MCP</b>
                </text>
                <For each={mcpList()}>
                  {(item) => (
                    <box flexDirection="row" gap={1}>
                      <text>•</text>
                      <text>
                        <b>{item.name}</b>
                      </text>
                      <text>{item.status.status}</text>
                    </box>
                  )}
                </For>
              </box>
            </Show>
          </box>
        )
      },
    })
  },
})
