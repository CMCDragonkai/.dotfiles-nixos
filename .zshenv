# ~/.zshenv
# Sourced by *every* zsh invocation (interactive + non-interactive).
# Keep it *environment-only* (no output, no prompts, no aliases, no completion).

# Load the shared session environment (HM vars + your exports)
if [ -r "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi