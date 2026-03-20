import type { Plugin } from "@opencode-ai/plugin"

export const PtPlugin: Plugin = async () => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool !== "bash") return
      const cmd = output.args.command as string
      if (cmd && /(?:^|\s)pytest(?:\s|$)/.test(cmd)) {
        output.args.command = cmd.replace(/(?:^|\s)pytest(?:\s|$)/, (m) => m.replace("pytest", "pt"))
      }
    },
  }
}
