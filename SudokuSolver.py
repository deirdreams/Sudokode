import numpy as np
import math

class SudokuSolver():

	def __init__(self, puzzle):
		self.puzzle = puzzle
		self.possNums = [1,2,3,4,5,6,7,8,9]

	def findEmpty(self, x, y):
		for i in range(x,9):
			for j in range(y,9):
				if self.puzzle[i][j] == 0:
					return i,j
		for i in range(0,9):
			for j in range(0,9):
				if self.puzzle[i][j] == 0:
					return i,j
		return -1,-1

	def isValid(self, x, y, val):
		row = [val != self.puzzle[x][j] for j in range(0,9)]
		if all(row):
			column = [val != self.puzzle[i][y] for i in range(0,9)]
			if all(column):
				#3x3 subgrid
				iStart= 3*int(math.floor(x/3))
				jStart = 3*int(math.floor(y/3))
				for i in range(iStart, iStart+3):
					for j in range(jStart, jStart+3):
						if self.puzzle[i][j] == val:
							return False
				return True
		return False

	def solve(self, i=0, j=0):
		i,j = self.findEmpty(i, j)
		if i < 0 or j < 0:
			return True
		for k in range(0,9):
			val = self.possNums[k]
			if self.isValid(i,j,val):
				self.puzzle[i][j] = val
				if self.solve(i, j):
					return True
				self.puzzle[i][j] = 0
		return False

	# def checkAll(self):
	# 	for i in range(0, 9):
	# 		for j in range(0, 9):
	# 			return self.isValid(i, j, self.puzzle[i][j])

	def main(self):
		self.solve()
		# print self.checkAll()
		return self.puzzle


puzzle = [[5,1,7,0,0,0,2,3,4],
		  [2,8,9,0,0,4,0,5,0],
		  [3,4,6,2,0,5,0,9,0],
		  [6,0,2,8,4,9,0,1,0],
		  [0,3,8,0,0,6,0,4,7],
		  [9,5,4,7,1,3,6,8,2],
		  [0,9,0,0,6,0,0,7,8],
		  [7,0,3,4,0,0,5,6,0],
   		  [0,0,0,0,0,0,0,0,0]]

puzzle2 = [[5,0,0,0,4,0,6,0,0],
		  [0,6,0,0,0,0,4,0,5],
		  [7,0,0,6,8,0,0,0,0],
		  [4,0,0,1,2,0,0,0,3],
		  [0,0,9,0,0,0,1,0,0],
		  [3,0,0,0,7,4,0,0,8],
		  [0,0,0,0,5,3,0,0,1],
		  [8,0,1,0,0,0,0,3,0],
   		  [0,0,3,0,1,0,0,0,9]]

ss = SudokuSolver(puzzle2)

print ss.main()

