# Integrated terminal safety

Never emit: `set*`, `shopt*`, `setopt*`, `exec*`, `exit`, `logout`, `kill $$`, `source*`, `. *`, `export*`.

Assume shell may not be bash. If you need bash features, use `bash -lc '...'`.

For `cmd | tee log` where cmd’s exit code matters:
`bash -lc 'cmd 2>&1 | tee log; exit ${PIPESTATUS[0]}'`

To force direnv for child process:
`direnv exec . bash -lc '...'`
