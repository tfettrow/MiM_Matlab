Vbl_L=mean(table2array(Vbl(:,2:4)),2);
Vbl_R=mean(table2array(Vbl(:,8:10)),2);
Typ_L=mean(table2array(Typ(:,2:4)),2);
Typ_R=mean(table2array(Typ(:,8:10)),2);
Vbl_var=mean(table2array(Vbl(:,[5:7 11:13])),2);
Typ_var=mean(table2array(Typ(:,[5:7 11:13])),2);
Vbl_ave=mean([Vbl_L,Vbl_R],2);
Typ_ave=mean([Typ_L,Typ_R],2);
Vbl_Vel=mean(table2array(Vbl(:,14:16)),2);
Typ_Vel=mean(table2array(Typ(:,14:16)),2);

d=[Typ_Vel(1:26,:)./100 Vbl_Vel(1:26,:)./100 OG.og_walkspeed_flat(1:26,:) OG.og_walkspeed_low(1:26,:) OG.og_walkspeed_med(1:26,:) OG.og_walkspeed_high(1:26,:)];
figure;boxplot(d,'Labels',{'Typ','VBL','OG Flat','OG Low','OG Med','OG High'})
title('HOA Velocity');
ylabel('Velocity (m/s)')
dd=[Typ_Vel(27:end,:)./100 Vbl_Vel(27:end,:)./100 OG.og_walkspeed_flat(27:end,:) OG.og_walkspeed_low(27:end,:) OG.og_walkspeed_med(27:end,:) OG.og_walkspeed_high(27:end,:)];
figure;boxplot(dd,'Labels',{'Typ','VBL','OG Flat','OG Low','OG Med','OG High'})
title('LOA Velocity');
ylabel('Velocity (m/s)')
b=[Typ_ave(1:26,:) Vbl_ave(1:26,:) OG.og_stepdur_flat(1:26,:) OG.og_stepdur_low(1:26,:) OG.og_stepdur_med(1:26,:) OG.og_stepdur_high(1:26,:)];
figure;boxplot(b,'Labels',{'Typ','VBL','OG Flat','OG Low','OG Med','OG High'})
title('HOA Step Duration');
ylabel('Duration (s)')
bb=[Typ_ave(27:end,:) Vbl_ave(27:end,:) OG.og_stepdur_flat(27:end,:) OG.og_stepdur_low(27:end,:) OG.og_stepdur_med(27:end,:) OG.og_stepdur_high(27:end,:)];
figure;boxplot(bb,'Labels',{'Typ','VBL','OG Flat','OG Low','OG Med','OG High'})
title('LOA Step Duration');
ylabel('Duration (s)')
c=[Typ_var(1:26,:).*100 Vbl_var(1:26,:).*100 OG.og_stepdurvar_flat(1:26,:) OG.og_stepdurvar_low(1:26,:) OG.og_stepdurvar_med(1:26,:) OG.og_stepdurvar_high(1:26,:)];
figure;boxplot(c,'Labels',{'Typ','VBL','OG Flat','OG Low','OG Med','OG High'})
title('HOA Step Duration Variance');
ylabel('Variance')
cc=[Typ_var(27:end,:).*100 Vbl_var(27:end,:).*100 OG.og_stepdurvar_flat(27:end,:) OG.og_stepdurvar_low(27:end,:) OG.og_stepdurvar_med(27:end,:) OG.og_stepdurvar_high(27:end,:)];
figure;boxplot(cc,'Labels',{'Typ','VBL','OG Flat','OG Low','OG Med','OG High'})
title('LOA Step Duration Variance');
ylabel('Variance')

