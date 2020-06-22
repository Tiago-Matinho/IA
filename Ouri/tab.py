from PIL import Image, ImageDraw, ImageFont


def draw_board(Tab, escolha):
	boardIm = Image.open('ouri.png')
	draw = ImageDraw.Draw(boardIm)

	pos = [(750, 85), (55, 85),
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
		if(i - 2 == escolha - 1):
			draw.text(cord, text, fill="red", font=font, align="center")
		else:
			draw.text(cord, text, fill="black", font=font, align="center")

	boardIm.save('Jogada.png')
	boardIm.close()
