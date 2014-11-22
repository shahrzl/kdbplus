
/Other type of kernels.

/Epanechnikov kernel
epKernel:{
        $[sqrt[x]<5;k:((3%4)*(1-(x xexp 2.0)%5)) % sqrt[5];k:0.0];
        :k
        }

/Rectangular kernel
rectKernel:{
        $[abs[x]<1;:0.5;:0.0];
        }
