%%% Zhaoyang Jin
%%% Read .h5 data download from https://fastmri.med.nyu.edu/

function readmulticoildata()
allfilenames=dir('F:\DwnlData\fastMRI\multicoil_val\*.h5');
for num=1:1378
    filename=allfilenames(num).name;
    % h5disp(filename,'/');

    test='F:\DwnlData\fastMRI\multicoil_val\';
    filenamenew=strcat(test,filename);
    %h5disp(filenamenew,'/');
    h5disp(filenamenew,'/')
    kspace = h5read(filenamenew,'/kspace'); 
    ismrmrd_header =h5read(filenamenew,'/ismrmrd_header'); 

    %reconstruction_esc =h5read(filename,'/reconstruction_esc'); % 
%     reconstruction_rss =h5read(filenamenew,'/reconstruction_rss'); 
%     test=reconstruction_rss(:,:,1); %     
%     figure;imshow(abs(test),[]) % end
 
    pkspace_r = getfield(kspace,'r');               % £¨single£©
    kspace_i = getfield(kspace,'i');

    multicoildata= complex(kspace_r,kspace_i); 
        
    dim=size(multicoildata);
    Yres=dim(1); 
    Xres=dim(2);
    Cres=dim(3); %% coil number
    Zres=dim(4); %% total 16 slices
    if((Yres==320)&(Xres==640)&(Cres==16)&(Zres==16))
        for z=1:Zres
            data3D=multicoildata(:,:,:,z);
            Image3D=ifftshift(ifft2(fftshift(data3D)));
            Image3D(:,end-159:end,:)=[]; 
            Image3D(:,1:160,:)=[]; 
            Image3D=single(Image3D);
            
%             for j=1:16
%               figure(j);imshow(abs(Image3D(:,:,j)),[]);
% %                 figure(j);imshow(angle(Image3D(:,:,j)),[]);
%             end   
            recname=strcat('F:\DwnlData\fastMRI\multicoil_images\brainmulticoil_file',num2str(num),'_slice',num2str(z),'.mat');
            save (recname,'Image3D');
        end
    else
        disp('skip');
    end
end