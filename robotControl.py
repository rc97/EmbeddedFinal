import serial
import pygame
import sys
import time

port = 'COM10'
baud = 112500

acc_commands = {1: 'z', 2: 'x', 3: 'c', 4: 'a', 5: '5', 6: 'd', 7: 'q', 8: 'w', 9: 'e'}

if __name__ == '__main__':
	pygame.init()
	size = (200, 200)
	screen = pygame.display.set_mode(size)
	pygame.display.set_caption("Robot Controller")
	pygame.key.set_repeat(1, 1)
	s = serial.Serial(port=port, baudrate=baud)
	acc_mode = False
	# acc_key = False
	while(True):
		cmd = 5
		keys = pygame.key.get_pressed()
		# if keys[pygame.K_f] and not acc_key:
		# 	acc_mode = not acc_mode
		# acc_key = keys[pygame.K_f]
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

		print(cmd, acc_mode)
		if acc_mode:
			ch = acc_commands[cmd]
		else:
			ch = str(cmd)
		# If any other key is pressed, assume stop
		s.write(ch.encode())

		if keys[pygame.K_q]:
			pygame.quit()
			sys.exit()
			break
		for event in pygame.event.get():
			if event.type == pygame.QUIT:
				pygame.quit()
				sys.exit()
			if event.type == pygame.KEYDOWN:
				if event.key == pygame.K_f:
					acc_mode = not acc_mode

		time.sleep(0.05)
