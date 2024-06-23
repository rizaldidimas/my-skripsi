function [besttour,mincost]=acs_budi(mjarak,iter,n_ants);
	m=n_ants;
	n=lenght(mjarak);
	e=.5;
	alpha=2;
	beta=1;

for i=1:n
	for j=1:n
		if mjarak(i,j)==0
			h(i,j)=0;
		else
			h(i,j)=1/mjarak(i,j);
		end
	end
end

thoinit=.1*ones(n);
for i=1:iter
	for i=1:m
		rute(i,1)=1;
	end
	for i=1:m
		mh=h;
		for j=1:n-1
			c=rute(i,j);
			mh(:,c)=0;
			tho=(thoinit(c,:).^beta).*(mh(c,:).^alpha);
			s=(sum(tho));
			p=(1/s).*tho;
			r=rand;
			s=0;
			for k=1:n
				s=s+p(k);
				if r<=s
					rute(i,j+1)=k;
					break
				end
			end
		end
	end

	rute_c=horzcat(rute,rute(:,1));
	for i=1:m
		f(i)=totdis(rute_c(i,:),mjarak);
	end
	jaraktot=f;
	[minf,idk]=min(f);
	ter=rute_c(idk,:);

	thoinit=(1-e)*thoinit;
	for i=1:m
		for j=1:n-1
			dt=1/f(i);
			thoinit(rute_c(i,j),rute_c(i,j+1))=thoinit(rute_c(i,j),rute_c(i,j+1))+dt;
		end
	end
end

besttour=ter;
mincost=totdis(ter,mjarak);
