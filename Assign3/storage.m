% Store current optimisation parameters
% L Drabsch
% 2/6/16

function Store = storage(L,Lold,Y,c,alpha,param,index,Store)

    Store.lagrangian(:,index) = L;
    if index == 1
        Store.error(:,index) = 2;
    else
        Store.error(:,index) = L-Lold;
    end
    Store.Y(:,index) = Y;
    Store.cost(:,index) = Cost(Y);
    Store.constraints(:,index) = c;
    Store.alpha(:,index) = alpha;
    Store.param(:,index) = param;

end