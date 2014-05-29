LFS scratch

figure(32);
clf(32)
hold on
for ij = 1:10
	plot(strehl(:,ij),PTD(:,ij),'.','Color',[ij/10 0 (ij-1)/10])
end
xlabel('Strehl')
ylabel('PTD')
