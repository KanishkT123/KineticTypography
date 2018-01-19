import numpy as np
import os
from nms import nms
import sys
import argparse
import caffe

def readable_dir(prospective_dir):
    """ 
    https://stackoverflow.com/questions/11415570/directory-path-types-with-argparse 
    """
    
    if not os.path.isdir(prospective_dir):
        raise Exception("readable_dir:{0} is not a valid path".format(prospective_dir))
    if os.access(prospective_dir, os.R_OK):
        return prospective_dir
    else:
        raise Exception("readable_dir:{0} is not a readable dir".format(prospective_dir))

def writeable_dir(prospective_dir):
    """ 
    https://stackoverflow.com/questions/11415570/directory-path-types-with-argparse 
    """
    
    if not os.path.isdir(prospective_dir):
        os.makedirs(prospective_dir)
    if os.access(prospective_dir, os.W_OK):
        return prospective_dir
    else:
        raise Exception("writeable_dir:{0} is not a writeable dir".format(prospective_dir))


def process_image(net, scales, image_path):
    image=caffe.io.load_image(image_path)
    image_height,image_width,channels=image.shape

    dt_results=[]
    
    for image_resize_height, image_resize_width in scales:
        transformer = caffe.io.Transformer({'data': (1,3,image_resize_height,image_resize_width)})
        transformer.set_transpose('data', (2, 0, 1))
        transformer.set_mean('data', np.array([104,117,123])) # mean pixel
        transformer.set_raw_scale('data', 255)  # the reference model operates on images in [0,255] range instead of [0,1]
        transformer.set_channel_swap('data', (2,1,0))  # the reference model has channels in BGR order instead of RGB
      
        net.blobs['data'].reshape(1,3,image_resize_height,image_resize_width)            
        transformed_image = transformer.preprocess('data', image)
        net.blobs['data'].data[...] = transformed_image
            
        # Forward pass.
        detections = net.forward()['detection_out']
        # Parse the outputs.
        det_label = detections[0,0,:,1]
        det_conf = detections[0,0,:,2]
        det_xmin = detections[0,0,:,3]
        det_ymin = detections[0,0,:,4]
        det_xmax = detections[0,0,:,5]
        det_ymax = detections[0,0,:,6]
        top_indices = [i for i, conf in enumerate(det_conf) if conf >= 0.6]
        top_conf = det_conf[top_indices]
        top_xmin = det_xmin[top_indices]
        top_ymin = det_ymin[top_indices]
        top_xmax = det_xmax[top_indices]
        top_ymax = det_ymax[top_indices]

        for i in range(top_conf.shape[0]):
            xmin = int(round(top_xmin[i] * image.shape[1]))
            ymin = int(round(top_ymin[i] * image.shape[0]))
            xmax = int(round(top_xmax[i] * image.shape[1]))
            ymax = int(round(top_ymax[i] * image.shape[0]))
            xmin = max(1,xmin)
            ymin = max(1,ymin)
            xmax = min(image.shape[1]-1, xmax)
            ymax = min(image.shape[0]-1, ymax)
            score = top_conf[i]
            dt_result=[xmin,ymin,xmax,ymin,xmax,ymax,xmin,ymax,score]
            dt_results.append(dt_result)
            
    dt_results = sorted(dt_results, key=lambda x:-float(x[8])) 
    nms_flag = nms(dt_results,0.3)

    dt_results = [this_dt for this_dt, this_nms in zip(dt_results, nms_flag) if this_nms]
    dt_results = [(dt[8], dt[0], dt[1], dt[2], dt[5]) for dt in dt_results]

    return dt_results

    
def main(args):

    caffe.set_mode_cpu()
    
    if args.use_multi_scale: 
        scales=((300,300),(700,700),(700,500),(700,300),(1600,1600))
    else:
        scales=((700,700),)

    net = caffe.Net(args.model_def,      # defines the structure of the model
                    args.model_weights,  # contains the trained weights
                    caffe.TEST)          # use test mode (e.g., don't perform dropout)

    for root, dirs, files in os.walk(args.image_dir):
        for filename in files:
            if filename[0] == ".": continue
            image_path = os.path.join(root, filename)
            box_path = os.path.join(root.replace(args.image_dir, args.box_dir), filename)

            boxes = process_image(net, scales, image_path)
            
            fp = open(box_path, "w")
            for box in boxes:
                print(",".join(map(str,box)), file=fp)
            fp.close()
    

if __name__ == "__main__":
    parser = argparse.ArgumentParser("Find text boxes in a directory of images")
    
    parser.add_argument("--modeldef", "-d", dest="model_def", default="./examples/TextBoxes/deploy.prototxt")
    parser.add_argument("--modelweights", "-w", dest="model_weights", default="./examples/TextBoxes/TextBoxes_icdar13.caffemodel")
    parser.add_argument('--multi', "-m", action='store_true', dest="use_multi_scale", help="Turns on use of multi_scales for finding boxes")
    parser.add_argument("--img", "-i", dest="image_dir", type=readable_dir, required=True)
    parser.add_argument("--boxes", "-b", dest="box_dir", type=writeable_dir, required=True)

    args = parser.parse_args()
    main(args)
