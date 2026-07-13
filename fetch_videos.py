import urllib.request
import urllib.parse
import re

queries = {
    'l_intro_2': 'Common Types of Cyber Attacks Malware Phishing Explained',
    'l_phish_1': 'Psychology of Phishing Social Engineering',
    'l_phish_2': 'How to spot a fake phishing email anatomy',
    'l_pass_1': 'How hackers crack passwords dictionary attack',
    'l_pass_2': 'Why Passphrases are better than passwords',
    'l_pass_3': 'How Password Managers and MFA work',
    'l_browse_2': 'Public Wi-Fi Security Risks VPN'
}

for lesson_id, query in queries.items():
    try:
        url = 'https://www.youtube.com/results?search_query=' + urllib.parse.quote(query)
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        html = urllib.request.urlopen(req).read().decode('utf-8')
        
        match = re.search(r'"videoId":"([a-zA-Z0-9_-]{11})"', html)
        if match:
            vid = match.group(1)
            print(f'{lesson_id}: {vid}')
        else:
            print(f'{lesson_id}: Not found')
    except Exception as e:
        print(f'{lesson_id}: ERROR {e}')
