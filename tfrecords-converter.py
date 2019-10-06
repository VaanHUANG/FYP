import socket
import importlib
import numpy as np
import tensorflow as tf
import sys
import os

def _int64_feature(value):
  return tf.train.Feature(int64_list=tf.train.Int64List(value=[value]))


def _bytes_feature(value):
  return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value]))

# images and labels array as input
def convert_to(images, labels, name):
  num_examples = labels.shape[0]
  if images.shape[0] != num_examples:
    raise ValueError("Images size %d does not match label size %d." %
                     (images.shape[0], num_examples))
  rows = images.shape[1]
  cols = images.shape[2]
  depth = images.shape[3]

  filename = os.path.join(FLAGS.directory, name + '.tfrecords')
  print('Writing', filename)
  writer = tf.python_io.TFRecordWriter(filename)
  for index in range(num_examples):
    image_raw = images[index].tostring()
    example = tf.train.Example(features=tf.train.Features(feature={
        'height': _int64_feature(rows),
        'width': _int64_feature(cols),
        'depth': _int64_feature(depth),
        'label': _int64_feature(int(labels[index])),
        'image_raw': _bytes_feature(image_raw)}))
    writer.write(example.SerializeToString())

# Remember to generate a file name queue of you 'train.TFRecord' file path
def read_and_decode(filename_queue):
  reader = tf.TFRecordReader()
  _, serialized_example = reader.read(filename_queue)
  key_dict = 
  features = tf.parse_single_example(
    serialized_example,
    #dense_keys=['image_raw', 'label'],
    # Defaults are not specified since both keys are required.
    #dense_types=[tf.string, tf.int64]
    )

  # Convert from a scalar string tensor (whose single string has
  image = tf.decode_raw(features['image_raw'], tf.uint8)

  image = tf.reshape(image, [my_cifar.n_input])
  image.set_shape([my_cifar.n_input])

  # OPTIONAL: Could reshape into a 28x28 image and apply distortions
  # here.  Since we are not applying any distortions in this
  # example, and the next step expects the image to be flattened
  # into a vector, we don't bother.

  # Convert from [0, 255] -> [-0.5, 0.5] floats.
  image = tf.cast(image, tf.float32)
  image = tf.cast(image, tf.float32) * (1. / 255) - 0.5

  # Convert label from a scalar uint8 tensor to an int32 scalar.
  label = tf.cast(features['label'], tf.int32)

  return image, label


filename_queue = tf.train.string_input_producer(
['./datasets/lsun-bedroom-full/000000.png',
'./datasets/lsun-bedroom-full/000001.png',
'./datasets/lsun-bedroom-full/000002.png',
'./datasets/lsun-bedroom-full/000003.png',
'./datasets/lsun-bedroom-full/000004.png',
'./datasets/lsun-bedroom-full/000005.png',
'./datasets/lsun-bedroom-full/000006.png',
'./datasets/lsun-bedroom-full/000007.png',
'./datasets/lsun-bedroom-full/000008.png',
'./datasets/lsun-bedroom-full/000009.png',]) #  list of files to read

image, label = read_and_decode(filename_queue)
convert_to(image, label, sampletfr)
'''
reader = tf.WholeFileReader()
key, value = reader.read(filename_queue)

my_img = tf.image.decode_png(value) # use decode_png or decode_jpeg decoder based on your files.

init_op = tf.initialize_all_variables()
with tf.Session() as sess:
  sess.run(init_op)

# Start populating the filename queue.

coord = tf.train.Coordinator()
threads = tf.train.start_queue_runners(coord=coord)

for i in range(1): #length of your filename list
  image = my_img.eval() #here is your image Tensor :)

print(image.shape)
Image.show(Image.fromarray(np.asarray(image)))

coord.request_stop()
coord.join(threads)
'''
