#!/bin/usr/env python3
# -*- coding: utf-8 -*-
# 
# 
# 
# author w
# version: v 0.1.0
# date 2025-09-11 17:15
#

import numpy as np
import matplotlib.pyplot as plt
from Python.Simu_Data_Processing import Simu_Data_Processing

# This part is not a real part of the simulator.
# Here we compare our simulation with real outdoor capture
# To do so we use the same data treatment for outdoor output camera data
# than for simulated output camera data

# 图像读取
img_file_name = '../data/250829_sample3_red_y/1_Image_20250829174939140_w2448_h2048_pMono12.raw'
# Camera_capture = plt.imread('../data/TEST_overcast_sky.tiff')

height = 2048
width = 2448
raw_ = np.fromfile(img_file_name, dtype='uint16')
Camera_capture = raw_.reshape(height, width, order='C')
# 海康raw导出时，前两个像素被写入了值，需要处理
Camera_capture[0, 0] = Camera_capture[1, 1]
Camera_capture[0, 1] = Camera_capture[1, 1]
Camera_capture[1, 0] = Camera_capture[1, 1]

# 图像处理
Camera_capture_8B = (np.uint8(np.floor((255 / (- 1 + 2 ** 16)) * Camera_capture)))
plt.figure()
plt.imshow(Camera_capture_8B, cmap='gray')
plt.colorbar()
plt.title('Outdoor capture')


# MaxCapture = np.amax(np.amax(Camera_capture))
print("outside capture results")
Camera_capture_double = (Camera_capture).astype('double')
AoP_expe_imframe, AoP_expe_meridianframe, DoLP_expe = Simu_Data_Processing(Camera_capture_double)
rows_print_cam, cols_print_cam = DoLP_expe.shape
X_mesh_print_cam = np.ones((rows_print_cam, 1)) * (np.arange(1, cols_print_cam + 1, 1))[np.newaxis, :]  # arange, [1, cols_print_cam + 1)， 1,2,3,...,1224
Y_mesh_print_cam = (np.arange(rows_print_cam, 1 + - 1, - 1))[:, np.newaxis] * np.ones((1, cols_print_cam)) # arange, [rows_print_cam, 0) ， 1024，1023，1022，...，1

# X_mesh_print_cam
# [[1,2,3,...,1224],
#  [1,2,3,...,1224],
#  ...
#  [1,2,3,...,1224]]

# Y_mesh_print_cam
# [[1024,1024,1024,...,1024],
#  [1023,1023,1023,...,1023],
#  ...
#  [1,   1,   1,   ...,1   ]]
# plt.pcolormesh中，认为从左下角为基础计算的，对应了Z(rows-1, 0)的值，不是以z的索引显示在坐标值上。

# map = cmap('C1')
plt.figure()
h9 = plt.pcolormesh(X_mesh_print_cam, Y_mesh_print_cam, AoP_expe_imframe, cmap='hsv')
# colormap(map)
# set(h,'EdgeColor','none')
plt.colorbar()
plt.axis('image')
plt.title('Outdoor capture AoP, camera frame (rad)')

plt.figure()
h10 = plt.pcolormesh(X_mesh_print_cam, Y_mesh_print_cam, AoP_expe_meridianframe, cmap='hsv')
# colormap(map)
# set(h,'EdgeColor','none')
plt.colorbar()
plt.axis('image')
plt.title('Outdoor capture AoP, meridian frame (rad)')

plt.figure()
h11 = plt.pcolormesh(X_mesh_print_cam, Y_mesh_print_cam, DoLP_expe, cmap='rainbow')
# set(h,'EdgeColor','none')
plt.colorbar()
plt.axis('image')
plt.title('Outdoor capture DoLP, meridian frame (rad)')
plt.show()
