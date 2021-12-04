# Slayter Teal, A20131271
# Oklahoma State University, CPE Senior
# Fall 2021, ECEN 4303

import torch
from torchvision import transforms, datasets
from fxpmath import Fxp
import pickle

test_data = datasets.MNIST('', train=False, download=True, transform=transforms.Compose([transforms.ToTensor()]))
test_set = torch.utils.data.DataLoader(test_data, batch_size=10, shuffle=False)


# Q16.16
total_bits = 32
frac_bits = 16

def writeWeightsAndBias():
    with open("mlp_state_dict", "rb") as file:
        mlp_state_dict = pickle.load(file)
        for param_tensor in mlp_state_dict:
            mem_file = param_tensor.replace(".", "_") + ".mem"
            with open (mem_file, "w") as outfile:
                for param in mlp_state_dict[param_tensor]:
                    if(param.size() != torch.Size([])):
                        for element in param:
                            result = toHex(Fxp(element.item(), n_int=total_bits-frac_bits, n_frac=frac_bits, signed=True).raw(), total_bits)
                            outfile.write(str(result).replace("0x", "") + " ")
                    else:
                        result = toHex(Fxp(param.item(), n_int=total_bits-frac_bits, n_frac=frac_bits, signed=True).raw(), total_bits)
                        outfile.write(str(result).replace("0x", "") + "\n")
                        

def parseTestPictures():
    index = 0
    total = 0
    num_of_photos = 5
    photos = []
    with torch.no_grad():
        for raw in test_set:
            X, y = raw
            pic = X.view(-1, 784)
            array = []
            for param in pic:
                for subparam in param:
                    if not index < 784:
                        photos.append(array)
                        array = []
                        index = 0
                    result = toHex(Fxp(subparam.item(), n_int=total_bits-frac_bits, n_frac=frac_bits, signed=False).raw(), total_bits)
                    array.append(str(result).replace("0x",""))
                    index += 1
            photos.append(array)
            total += 1
            if (total > num_of_photos): 
                break

        i = 0
        for photo in photos:
            i += 1
            photoFile = "picture_" + str(i) + ".mem"
            print(str(y[i-1].item()) + " " + photoFile)
            with open(photoFile, "w") as outfile:
                for pixel in photo:
                    outfile.write(pixel + " ")
            


def toHex(num, bits):
    return hex((num + (1<<bits)) % (1<<bits))

if __name__ == "__main__":
    writeWeightsAndBias()
    # parseTestPictures()

