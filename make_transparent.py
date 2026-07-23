from PIL import Image

# Load the image
img_path = r'C:\Users\PMLS\.gemini\antigravity-ide\brain\2ac769d0-30fd-4217-8f85-bade77c34335\cyberguardian_logo_white_bg_1784725487572.png'
img = Image.open(img_path).convert('RGBA')

data = img.getdata()
new_data = []
for item in data:
    # Change all white (also shades of white)
    # to transparent
    if item[0] > 240 and item[1] > 240 and item[2] > 240:
        new_data.append((255, 255, 255, 0))
    else:
        new_data.append(item)

img.putdata(new_data)
img.save(r'c:\Users\PMLS\OneDrive\Desktop\6th Semester\Mobile App development\flutter_application_1\flutter_application_1\assets\images\cyberguardian_logo.png', 'PNG')
print('Transparent logo saved successfully.')
