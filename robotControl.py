import serial
import pygame
import sys
import time

port = 'COM10'
baud = 112500

if __name__ == '__main__':
	pygame.init()
	size = (200, 200)
	screen = pygame.display.set_mode(size)
	pygame.display.set_caption("Robot Controller")
	pygame.key.set_repeat(1, 1)
	s = serial.Serial(port=port, baudrate=baud)
	while(True):
		cmd = 5
		keys = pygame.key.get_pressed()
		if keys[pygame.K_UP]:
			cmd = 8
			# print('up')
		elif keys[pygame.K_DOWN]:
			cmd = 2
			# print('down')

		if keys[pygame.K_LEFT]:
			cmd -= 1
			# print('left')
		elif keys[pygame.K_RIGHT]:
			cmd += 1
			# print('right')

		print(cmd)
		# If any other key is pressed, assume stop
		s.write(str(cmd).encode())

		if keys[pygame.K_q]:
			pygame.quit()
			sys.exit()
			break
		for event in pygame.event.get():
			if event.type == pygame.QUIT:
				pygame.quit()
				sys.exit()

		time.sleep(0.05)
