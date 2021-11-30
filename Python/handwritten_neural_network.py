# Slayter Teal, A20131271
# Oklahoma State University, CPE Senior
# Fall 2021, ECEN 4303

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torchvision import transforms, datasets
from fxpmath import Fxp

training_data = datasets.MNIST('', train=True, download=True,
                            transform=transforms.Compose([transforms.ToTensor()]))

test_data = datasets.MNIST('', train=False, download=True, 
                            transform=transforms.Compose([transforms.ToTensor()]))

training_set = torch.utils.data.DataLoader(training_data, batch_size=10, shuffle=True)
test_set = torch.utils.data.DataLoader(test_data, batch_size=10, shuffle=False)

class NeuralNetwork(nn.Module): 
    def __init__(self):
        super().__init__()
        self.hidden_layer = nn.Linear(28*28, 50)
        self.output_layer = nn.Linear(50, 10)
    
    def forward(self, x):
        # x = F.relu(self.input_layer(x))
        x = F.relu(self.hidden_layer(x))
        x = self.output_layer(x)
        return F.log_softmax(x, dim=1)

def trainModel(model, optimizer, training_set):
    for epoch in range(4): 
        for data in training_set:
            X, y = data  
            model.zero_grad()  
            output = model(X.view(-1,784))  
            loss = F.nll_loss(output, y)  
            loss.backward()  
            optimizer.step()  
        print(loss)  

def getModelAccuracy(model, test_set):
    correct = 0
    total = 0
    with torch.no_grad(): # get the accuracy of the model.
        for data in test_set:
            X, y = data
            output = model(X.view(-1,784))
            for idx, i in enumerate(output):
                if torch.argmax(i) == y[idx]:
                    correct += 1
                total += 1

    return round(correct/total, 3);

def getWeightsAndBias(model):
    parseToFixedPoint(model.state_dict())

def parseToFixedPoint(state_dict):
    for layer in state_dict:
        with open(layer, "w") as outputFile:
            for param in state_dict[layer]:    
                if(param.size() != torch.Size([])):
                    for item in param:
                        outputFile.write(str(Fxp(item.item(), 
                            n_int=8, n_frac=8, signed=True).raw())+ " ")
                        outputFile.write("\n")
                else:
                    outputFile.write(str(Fxp(param.item(), 
                            n_int=8, n_frac=8, signed=True).raw())+ "\n")

model = NeuralNetwork()
optimizer = optim.Adam(model.parameters(), lr=0.001)

trainModel(model, optimizer, training_set)
print("Accuracy: ", getModelAccuracy(model, test_set))
getWeightsAndBias(model)








