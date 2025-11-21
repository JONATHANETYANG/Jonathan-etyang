classdef ProcessModel
properties
    Ca0;
    A0;
    R;
    Ea;
end
methods
    function obj=ProcessModel(x,y,z,b)
        obj.Ca0=x;
        obj.A0=y;
        obj.R=z;
        obj.Ea=b;
    end
    function K=RateConstant(obj,T)
        K=obj.A0*exp((-obj.Ea)./(obj.R.*T));
    end
    function Xa=Conversion(obj,T)
        k=obj.RateConstant(T);
        Xa=(k.*T')./(1+k.*T');
    end
    function Rb=ProductionRate(obj,T)
        k=obj.RateConstant(T);
        Xa=obj.Conversion(T);
        Rb=K.*obj.Ca0.*(1-Xa);
    end
    function plotting(obj,T)
        k=obj.RateConstant(T);
        Xa=obj.Conversion(T);
        Rb= obj.ProductionRate(T)

        fig1=figure;
        subplot(2,2,1);
         
         plot(T,k,'r-','LineWidth',2);
         subplot(2,2,2);
          
          [X,Y,Z]=meshgrid(T,k,Xa);
          surf(X,Y,Z);
          subplot(2,2,3);
          mesh(X,Y,Z);
          subplot(2,2,4);
          contour(X,Y,Z);
  
        fig2=figure;
         RB_Xa = Rb(:,:,end)
         surf(X,Y,RB_Xa)

         RB_k = Rb(end,:,:)

         sz = size(Rb)
         RB_K = reshape(RB_k,sz(2),sz(3))
         




          







end
end









   







