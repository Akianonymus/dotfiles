// Server entrypoint: intentionally dependency-free.
// (File-based discovered plugins can't resolve `@opencode/plugin` on the
// server, so we export a plain object instead of using Plugin.define.)
export default {
  id: "cache-hit",
  setup() {},
}
