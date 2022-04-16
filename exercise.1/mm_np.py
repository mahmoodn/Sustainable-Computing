import numpy as np
import time

N = 8192
t = time.time()
X = np.random.uniform(0,10,[N,N])
Y = np.random.uniform(0,10,[N,N])
result = np.zeros((N,N))   
elapsed_time = time.time() - t
print("Initialization took", elapsed_time)
# iterate through rows of X
t = time.time()
result = np.matmul(X,Y)
elapsed_time = time.time() - t
print("MM took", elapsed_time)
# for r in X:
   # print(r)
# print("")
# for r in Y:
   # print(r)
# print("")
# for r in result:
   # print(r)
