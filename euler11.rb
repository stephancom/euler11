#!/usr/bin/env ruby

require 'matrix'

#           _         _ _ 
#  ___ _  _| |___ _ _/ / |
# / -_) || | / -_) '_| | |
# \___|\_,_|_\___|_| |_|_|

# programming assignment for Sonian
# (c) 2013 stephan.com
# started 7:40pm 17oct13
# finished 8:47pm

# return the greatest product of four adjacent numbers in the grid
# adjacency is defined as continuous horizontally or diagonally

# note that leading zeroes were removed from the given input field
# because ruby interprets that as indicating octal numbers.  08 == bad :)

# I am tempted to also return the actual _coordinates_ of the winning product
# but this is not asked for....

# be it known that while I'm not submitting tests as a part of this,
# I did quite a lot of "bench testing" using puts statements :) old skool :)
# puts statements left in to "show my work"

# I sure hope it's right...

input_field =	[	
					[  8,  2, 22, 97, 38, 15,  0, 40,  0, 75,  4,  5,  7, 78, 52, 12, 50, 77, 91,  8],
					[ 49, 49, 99, 40, 17, 81, 18, 57, 60, 87, 17, 40, 98, 43, 69, 48,  4, 56, 62,  0],
					[ 81, 49, 31, 73, 55, 79, 14, 29, 93, 71, 40, 67, 53, 88, 30,  3, 49, 13, 36, 65],
					[ 52, 70, 95, 23,  4, 60, 11, 42, 69, 24, 68, 56,  1, 32, 56, 71, 37,  2, 36, 91],
					[ 22, 31, 16, 71, 51, 67, 63, 89, 41, 92, 36, 54, 22, 40, 40, 28, 66, 33, 13, 80],
					[ 24, 47, 32, 60, 99,  3, 45,  2, 44, 75, 33, 53, 78, 36, 84, 20, 35, 17, 12, 50],
					[ 32, 98, 81, 28, 64, 23, 67, 10, 26, 38, 40, 67, 59, 54, 70, 66, 18, 38, 64, 70],
					[ 67, 26, 20, 68,  2, 62, 12, 20, 95, 63, 94, 39, 63,  8, 40, 91, 66, 49, 94, 21],
					[ 24, 55, 58,  5, 66, 73, 99, 26, 97, 17, 78, 78, 96, 83, 14, 88, 34, 89, 63, 72],
					[ 21, 36, 23,  9, 75,  0, 76, 44, 20, 45, 35, 14,  0, 61, 33, 97, 34, 31, 33, 95],
					[ 78, 17, 53, 28, 22, 75, 31, 67, 15, 94,  3, 80,  4, 62, 16, 14,  9, 53, 56, 92],
					[ 16, 39,  5, 42, 96, 35, 31, 47, 55, 58, 88, 24,  0, 17, 54, 24, 36, 29, 85, 57],
					[ 86, 56,  0, 48, 35, 71, 89,  7,  5, 44, 44, 37, 44, 60, 21, 58, 51, 54, 17, 58],
					[ 19, 80, 81, 68,  5, 94, 47, 69, 28, 73, 92, 13, 86, 52, 17, 77,  4, 89, 55, 40],
					[  4, 52,  8, 83, 97, 35, 99, 16,  7, 97, 57, 32, 16, 26, 26, 79, 33, 27, 98, 66],
					[ 88, 36, 68, 87, 57, 62, 20, 72,  3, 46, 33, 67, 46, 55, 12, 32, 63, 93, 53, 69],
					[  4, 42, 16, 73, 38, 25, 39, 11, 24, 94, 72, 18,  8, 46, 29, 32, 40, 62, 76, 36],
					[ 20, 69, 36, 41, 72, 30, 23, 88, 34, 62, 99, 69, 82, 67, 59, 85, 74,  4, 36, 16],
					[ 20, 73, 35, 29, 78, 31, 90,  1, 74, 31, 49, 71, 48, 86, 81, 16, 23, 57,  5, 54],
					[  1, 70, 54, 71, 83, 51, 54, 69, 16, 92, 33, 48, 61, 43, 52,  1, 89, 19, 67, 48]
				]
field_size = 20
group_size = 4

# just for sanity, let's make sure the grid actually has the right group_size
# I'm mainly doing this because Ruby 2-d arrays annoy me
puts "Grid has wrong number of rows - #{input_field.count}" unless input_field.count == field_size
input_field.each_with_index do |row, i|
	puts "Row #{i} has wrong number of columns" unless row.count == field_size
end

# I've never used the Matrix class before, it looks perfect for my needs
matrix = Matrix.rows(input_field)

# given an input vector (or array) and a number of elements, finds the maximum product of this number of elements
def max_product_in_vector(vector, group_size)
	max_product = 0
	(0..(vector.size-group_size)).each do |i|
		# if we were really obsessed about performance, 
		# we could check to see if there was a 0 in 
		# the next N numbers and skip till after the zero.
		# not gonna bother...
		product = vector[i...i+group_size].inject(:*)
		# puts "sanity #{vector[i...i+group_size].join(',')} == #{product}"
		# puts max_product
		max_product = product if product > max_product
	end
	max_product
end

# given as input a set of N diagonals, find the maximum product of each diagonal
# note that we get group size from the number of vectors given
# all vectors are assumed to be the same size
def max_product_in_diagonals(vectors)
	max_product = 0
	group_size = vectors.size
	# puts vectors
	(0..(vectors.first.size-group_size)).each do |i|
		product = 1
		vectors.each_with_index do |vector, j|
			product *= vector[i+j]
			# print "#{vector[i+j]}, "
			# $stdout.flush
		end
		# puts product
		# puts max_product
		max_product = product if product > max_product
		# puts max_product
	end
	max_product
end

def solve(matrix, size, group_size)
	max_product = 0

	# compute each row retaining max
	max_product = matrix.row_vectors.map { |row| max_product_in_vector(row, group_size) }.max

	# compute each column retaining max
	max_columns = matrix.column_vectors.map { |column| max_product_in_vector(column, group_size) }.max
	max_product = max_columns if max_columns > max_product

	# the diagonals almost as elegant...
	diagonal_product = 0
	(0..(size-group_size)).each do |i|
		# take a group of N rows
		rowgroup = matrix.row_vectors[i...i+group_size]

		# compute the diagonal product (upper left to lower right)
		product = max_product_in_diagonals(rowgroup)
		diagonal_product = product if product > diagonal_product

		# and then as long as we have that group handy, 
		# just reverse it to compute the other direction (lower left to upper right)
		product = max_product_in_diagonals(rowgroup.reverse)
		diagonal_product = product if product > diagonal_product
	end

	max_product = diagonal_product if diagonal_product > max_product

	# puts "max = #{max_product}"
	max_product
end

# solve for a couple of trivial cases just to double check
# yes, I probably should write formal tests for this, I'm just using my eyes
# puts solve(Matrix[[0,0,0,0],[0,0,0,0],[0,999,0,0],[0,0,0,999]], 4, 2)==0
# puts solve(Matrix[[100,100,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]], 4, 2)==10000
# puts solve(Matrix[[100,0,0,0],[100,0,0,0],[200,0,0,400],[200,0,0,400]], 4, 2)==160000
# puts solve(Matrix[[100,0,0,0],[100,0,0,0],[0,200,100,0],[0,0,200,0]], 4, 2)==40000
# puts solve(Matrix[[100,0,999,0],[100,0,0,999],[0,200,100,0],[0,0,200,0]], 4, 2)==998001

solution = solve(matrix, field_size, group_size)

puts "The maximum product from the given matrix is #{solution}"












