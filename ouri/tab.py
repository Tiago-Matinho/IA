from PIL import Image, ImageDraw, ImageFont


def draw(Tab):
	
	boardIm = Image.open('ouri.png')
	draw = ImageDraw.Draw(boardIm)

	pos = [(55, 85), (750, 85),
	(154, 130),
	(254, 130),
	(354, 130),
	(454, 130),
	(554, 130),
	(654, 130),
	(654, 40),
	(554, 40),
	(454, 40),
	(354, 40),
	(254, 40),
	(154, 40)]

	font = ImageFont.truetype(r'Arial.ttf', 20)

	for i in range(len(Tab)):
		text = str(Tab[i])
		cord = pos[i]
		if(len(text) > 1):
			cord = (cord[0] - 5, cord[1])
		draw.text(cord, text, fill="black", font=font, align="center")

	boardIm.show()
	boardIm.save('novaJogada.png')


if __name__ == "__main__":
	tab = [4,4,4,4,4,4,40,40,40,40,40,40,40,40]
	draw(tab)