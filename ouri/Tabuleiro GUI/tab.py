try:
	from PIL import Image
except ModuleNotFoundError:
		try:
			import pip
			pip.main['install', 'pillow']
		except ModuleNotFoundError:
			print("Pillow and pip were not found run the setup.sh")


def draw(Tab):
	boardIm = Image.open('ouri.png')

	pos = [(38, 75), (735, 75),
	(138, 120),
	(238, 120),
	(338, 120),
	(438, 120),
	(538, 120),
	(638, 120),
	(638, 30),
	(538, 30),
	(438, 30),
	(338, 30),
	(238, 30),
	(138, 30)]

	numbers = ['1.png', '2.png', '3.png', '4.png', '5.png', '6.png', '7.png', '8.png', '9.png', '10.png', '11.png', '12.png', '13.png', '14.png', '15.png', '16.png', '17.png', '18.png', '19.png', '20.png', '21.png', '22.png', '23.png', '24.png', '25.png']

	for i in range(len(Tab)):
		if Tab[i] != 0:
			boardIm.paste(Image.open(numbers[Tab[i] - 1]), pos[i])

	boardIm.save('novaJogada.png')


def main():
	Tab = [1,0, 4,4,4,4,4,0,2,2,2,2,1,1]
	draw(Tab)


if __name__ == "__main__":
	main()
