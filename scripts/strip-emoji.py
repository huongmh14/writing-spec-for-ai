# Remove emoji/icons from markdown files, replacing checklist markers with ASCII.
import re, sys, pathlib

REPLACEMENTS = {
    '✅': '[x]', '✔️': '[x]', '☑️': '[x]', '❌': '[ ]', '✖️': '[ ]', '☒': '[ ]',
    '⚠️': '(warning)', '⚠': '(warning)', '🚫': '(blocked)', '⛔': '(blocked)',
    '🟢': '(green)', '🟡': '(yellow)', '🔴': '(red)', '🔵': '(blue)',
    '📊': '', '🎯': '', '👉': '', '🔍': '', '📝': '', '💡': '', '⭐': '', '🔥': '',
    '📌': '', '🧭': '', '🛡️': '', '🔧': '', '📚': '', '🚀': '', '✨': '',
    '❓': '', '❗': '', 'ℹ️': '', '🔴': '(red)', '🟠': '(orange)', '🟣': '(purple)',
}
EMOJI_RE = re.compile(
    '['
    '\U0001F000-\U0001FAFF'
    '\u2600-\u27BF'
    '\u2B00-\u2BFF'
    '\uFE0F'
    '\u2700-\u27BF'
    ']+ ?', flags=re.UNICODE)  # arrows U+2190-21FF are text, kept; eat one trailing space

def clean(text):
    for k, v in REPLACEMENTS.items():
        text = re.sub(re.escape(k) + ' ?', '', text) if v == '' else text.replace(k, v)
    text = EMOJI_RE.sub('', text)
    # collapse leftover spaces before punctuation/newlines
    text = re.sub(r'(?<!\[)[ \t]+([,.;:)\]])', r'\1', text)  # keep the '[ ]' checkbox
    text = re.sub(r'\n{3,}', '\n\n', text)
    return text

if sys.argv[1:] == ['--selftest']:
    assert clean('a → b') == 'a → b', 'arrow must survive'
    assert clean('❌ todo') == '[ ] todo' and clean('- [ ] x') == '- [ ] x', 'checkbox must survive'
    assert clean('x 🎯 y') == 'x y', 'emoji removed without double space'
    assert clean('ok ✅') == 'ok [x]', 'check mark mapped'
    print('selftest ok'); sys.exit(0)

changed = []
for root in sys.argv[1:]:
    for p in pathlib.Path(root).rglob('*.md'):
        try:
            t = p.read_text(encoding='utf-8')
        except Exception:
            continue
        n = clean(t)
        if n != t:
            p.write_text(n, encoding='utf-8', newline='')
            changed.append(str(p))
print('\n'.join(changed))
print(f'--- {len(changed)} files changed ---')
