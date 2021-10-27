# Slayter Teal, A20131271
# Oklahoma State University, CPE Senior
# Fall 2021, ECEN 4303

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torchvision import transforms, datasets
import numpy as np

training_data = datasets.MNIST('', train=True, download=True,
                            transform=transforms.Compose([transforms.ToTensor()]))

test_data = datasets.MNIST('', train=False, download=True, 
                            transform=transforms.Compose([transforms.ToTensor()]))

training_set = torch.utils.data.DataLoader(training_data, batch_size=10, shuffle=True)
test_set = torch.utils.data.DataLoader(test_data, batch_size=10, shuffle=False)

class NeuralNetwork(nn.Module): 
    def __init__(self):
        super().__init__()
        self.input_layer = nn.Linear(28*28, 64)
        self.hidden_layer = nn.Linear(64, 64)
        self.output_layer = nn.Linear(64, 10)
    
    def forward(self, x):
        x = F.relu(self.input_layer(x))
        x = F.relu(self.hidden_layer(x))
        x = self.output_layer(x)
        return F.log_softmax(x, dim=1)

def trainModel(model, optimizer, training_set):
    for epoch in range(4): # set range for however many epochs you want to run. 
        for data in training_set:
            X, y = data  # X is the batch of features, y is the batch of targets.
            model.zero_grad()  # sets gradients to 0 before loss calc.
            output = model(X.view(-1,784))  # pass in the reshaped batch (recall they are 28x28 atm)
            loss = F.nll_loss(output, y)  # calc and grab the loss value
            loss.backward()  # apply this loss backwards thru the model's parameters
            optimizer.step()  # attempt to optimize weights to account for loss/gradients
        print(loss)  # print loss. We hope loss (a measure of wrong-ness) declines! 

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
    input_layer_wb = model.input_layer.state_dict()
    print(input_layer_wb['weight'])
    print(input_layer_wb['bias'])

    hidden_layer_wb = model.hidden_layer.state_dict()
    print(hidden_layer_wb['weight'])
    print(hidden_layer_wb['bias'])

    output_layer_wb = model.output_layer.state_dict()
    print(output_layer_wb['weight'])
    print(output_layer_wb['bias'])

    np.savetxt('input_layer_weight.txt', input_layer_wb['weight'])
    np.savetxt('input_layer_bias.txt', input_layer_wb['bias'])
    np.savetxt('hidden_layer_weight.txt', hidden_layer_wb['weight'])
    np.savetxt('hidden_layer_bias.txt', hidden_layer_wb['bias'])
    np.savetxt('output_layer_weight.txt', output_layer_wb['weight'])
    np.savetxt('output_layer_bias.txt', output_layer_wb['bias'])

model = NeuralNetwork()
optimizer = optim.Adam(model.parameters(), lr=0.001)

trainModel(model, optimizer, training_set)
print("Accuracy: ", getModelAccuracy(model, test_set))
getWeightsAndBias(model)








