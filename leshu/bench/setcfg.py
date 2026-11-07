"""setcfg.py <ini> key=value[,key=value...]: sets keys (and key\\default=false) in an emulator ini."""
import sys

path, spec = sys.argv[1], sys.argv[2]
want = dict(item.split('=', 1) for item in spec.split(',') if item)
data = open(path, 'rb').read().decode('utf-8')
nl = '\r\n' if '\r\n' in data else '\n'
lines = data.split(nl)
seen = set()
for i, line in enumerate(lines):
    for key, value in want.items():
        if line.startswith(key + '\\default='):
            lines[i] = key + '\\default=false'
        elif line.startswith(key + '='):
            lines[i] = key + '=' + value
            seen.add(key)
missing = set(want) - seen
open(path, 'wb').write(nl.join(lines).encode('utf-8'))
print('set', sorted(seen), 'missing', sorted(missing))
