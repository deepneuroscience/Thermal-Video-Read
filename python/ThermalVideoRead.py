# improved the efficiency by using matrix calculation instead of interception
# add astype('uint32') to resolve the problem of bit-overflow
import numpy as np


def read_file(frame_height, frame_width):
    # reading data from outside file
    file = np.fromfile('coffee.dat', dtype='uint16')
    #file = np.fromfile('desk.dat', dtype='uint16')
    file = np.reshape(file, [-1, frame_height*frame_width + 4])
    file = (np.transpose(file).astype('uint16'))
    return file


def get_img_frames(file,frame_height, frame_width ):
    # assigning pixels to image-frame matrix 'img_frames'
    num_frames = np.size(file, 1)
    num_frames = 50
    file_segment=file[0:320*240, 0:50]; 
    img_frames = np.reshape(file_segment[0:320*240, :], [frame_height, frame_width, num_frames])
    #img_frames = np.reshape(file[0:320*240, :], [frame_height, frame_width, num_frames])
    img_frames = (img_frames - 27315) / 100
    return img_frames


def get_time_arr(file):
    # getting time array from the last two rows of read-in file
    pre_time_arr = file[320*240+2:, :]
    pre_time_arr_high = (np.round(pre_time_arr[:, :]) & 255) << 8
    pre_time_arr_low = np.round(pre_time_arr[:, :]) >> 8
    time_arr = (pre_time_arr_high + pre_time_arr_low).astype('uint32')
    new_time_arr = ((np.round(time_arr[0, :]) << 16) + time_arr[1, :]) / 1000
    return new_time_arr

