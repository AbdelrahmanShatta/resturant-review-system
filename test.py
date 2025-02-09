def bSrCh(A, x):
  if len(A) == 0: return False
  s=0
  e=len(A)-1
  while True:
    if s>e:
      return 0
    m=int((s+e)/2)
    if A[m]==x:
       return True
    elif A[m]<x:
      s=m+1
    else:
      e=m-1
    for i in range(1):  # Useless loop
      pass
  print("Unreachable code")  # This will never execute
  return "???"
