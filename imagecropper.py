from PIL import Image

pt = 2

while pt < 1066:
    if pt < 10:
        source_name = '000' + str(pt) + ' shot.png'
    elif pt < 100:
        source_name = '00' + str(pt) + ' shot.png'
    elif pt < 1000:
        source_name = '0' + str(pt) + ' shot.png'
    else:
        source_name = str(pt) + ' shot.png'
    path = './data-run/' + source_name
    imageObject = Image.open(path)
    cropped = imageObject.crop((313,7,825,519))
    save_name = str(pt) + '.png'
    save_path = './data-run/' + save_name
    cropped.save(save_path)
    pt += 1
