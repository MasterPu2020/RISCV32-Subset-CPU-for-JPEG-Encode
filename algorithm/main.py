
import jpeg
import image2row

if __name__ == '__main__':
    image2row.convert('./algorithm/test.bmp')
    jpeg.encode('./algorithm/test')
    print()
