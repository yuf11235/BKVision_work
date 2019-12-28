function [Z,infoOut] = FourWayIntegrate(PP,QQ)
%FourWayIntegration: Integration Z from P=Zx Q=Zy
%Input:
%  P,Q:P¡ÖZx Q¡ÖZy
%Output:
%  Z: depth matrix
%  infoOut: {time,errPQ};errPQ:  errPQ(Z(x,y))=mean(mean((Zx-P).*(Zx-P)))+mean(mean((Zy-Q).*(Zy-Q))
%Reference:
% (Code)Wenner, A., & Brune, C. (n.d.). Reconstructing DePthinformation from Surface Normal Vectorsinhaltsverzeichnis, 12.
%       Klette, R., CamPus, T., & Zealand, N. (n.d.). Height data from gradient fields, (1).
%       V. Rodehorst, "Vertiefende Analyse eines Gestalts-Constraints von Aloimonos und Shulman", Technischer Bericht, CV-Bericht 8,institut f¨¹r Technischeinformatik, TU Berlin, 1993.
%Algorithm:
%   1----P
%   |  -------------     -------------
%   | |S----------->|   | ¡Ä¡Ä      T |
%   Q | ----------->|   | | | ...     |    ©°©¤©¤©Ð©¤©¤©´
%     |      :      |   | | |         |    ©¦ a  ©¦ b ©¦
%     |           T |   | S           |    ©À©¤©¤©à©¤©¤©È
%      -------------     -------------     ©¦ c  ©¦(d)©¦
%      -------------     -------------     ©¸©¤©¤©Ø©¤©¤©¼
%     |             |   |           S |
%     |      :      |   |     ... | | |
%     | <---------S |   |         | | |
%     | <---------S |   | T      ¡Å¡Å |
%      -------------     -------------
    %%initial
    [hP,wP]=size(PP);
    [hQ,wQ]=size(QQ);
    if(hP-1~=hQ || wP~=wQ-1)
        error('Input parameter number error');
    end
    P=([PP(:,1),PP]+[PP,PP(:,wP)])/2;
    Q=([QQ(1,:);QQ]+[QQ;QQ(hQ,:)])/2;
    h=hP;
    w=wQ;
    
    tic;
    Z=zeros(h,w,'double');
    Z1=zeros(h,w,'double');
    Z2=zeros(h,w,'double');
    Z3=zeros(h,w,'double');
    Z4=zeros(h,w,'double');
    d=0.0;
    steigungx=0.0;
    steigungy=0.0;
    %initialisiere AnfangsPunkt fur jeden Scan mit der Hohe 0
    % Scan zeilenweis evon links oben nach rechts unten
    %% Left-top to Bottom-right
    % SPezialfall erste SPalte fur jeden Scan
    for jj=2:w  
        % Scan zeilenweise von links oben nach rechts unten
        steigungx = (P(1,jj-1) + P(1,jj) ) / 2; 
        Z1(1, jj) = Z1(1, jj-1) + steigungx ;
    end
    % SPezialfall erste Zeile fur jeden Scan
    for ii=2:h  
        % Scan zeilenweise von links oben nach rechts unten
        steigungy = (Q(ii-1, 1) + Q(ii, 1) ) / 2; 
        Z1(ii, 1) = Z1(ii-1, 1) + steigungy ;
    end
    % Normalfall Punktiminneren fur jeden Scan
    for ii= 2:h
        for jj = 2:w
            % Scan zeilenweise von links oben nach rechts unten
            steigungx = (P(ii-1 , jj-1 ) + P(ii , jj-1 ) + P(ii-1 , jj  ) + P(ii, jj ) ) / 4 ;
            steigungy = (Q(ii-1 , jj-1 ) + Q(ii , jj-1 ) + Q(ii-1 , jj  ) + Q(ii, jj ) ) / 4 ;
            Z1(ii, jj ) = ( Z1(ii , jj-1 ) + Z1(ii-1 , jj  ) ) / 2 + ( steigungx + steigungy ) / 2 ;
        end
    end
    %% Left-bottom to Top-right
    % SPezialfall erste SPalte fur jeden Scan
    for jj=2:w  
        % Scan zeilenweise von links oben nach rechts unten
        steigungx = (P(h,jj-1) + P(h,jj) ) / 2; 
        Z2(h, jj) = Z2(h, jj-1) + steigungx ;
    end
    % SPezialfall erste Zeile fur jeden Scan
    for ii=h-1:-1:1 
        % Scan zeilenweise von links oben nach rechts unten
        steigungy = (Q(ii+1, 1) + Q(ii, 1) ) / 2; 
        Z2(ii, 1) = Z2(ii+1, 1) - steigungy ;
    end
    % Normalfall Punktiminneren fur jeden Scan
    for ii= h-1:-1:1
        for  jj = 2:w
            % Scan zeilenweise von links oben nach rechts unten
            steigungx = (P(ii+1 , jj-1 ) + P(ii , jj-1 ) + P(ii+1 , jj  ) + P(ii, jj ) ) / 4 ;
            steigungy = (Q(ii+1 , jj-1 ) + Q(ii , jj-1 ) + Q(ii+1 , jj  ) + Q(ii, jj ) ) / 4 ;
            Z2(ii, jj ) = ( Z2(ii , jj-1 ) + Z2(ii+1 , jj  ) ) / 2 + ( steigungx - steigungy ) / 2 ;
        end
    end   
      
   %% Bottom-right to Left-top    
    % SPezialfall erste SPalte fur jeden Scan
    for jj=w-1:-1:1  
        % Scan zeilenweise von links oben nach rechts unten
        steigungx = (P(h, jj) + P(h, jj+1) ) / 2; 
        Z3(h, jj) = Z3(h, jj+1) - steigungx ;
    end
    % SPezialfall erste Zeile fur jeden Scan
    for ii=h-1:-1:1 
        % Scan zeilenweise von links oben nach rechts unten
        steigungy = (Q(ii, w) + Q(ii+1, w) ) / 2; 
        Z3(ii, w) = Z3(ii+1, w) - steigungy ;
    end
    % Normalfall Punktiminneren fur jeden Scan
    for ii= h-1:-1:1  
        for jj = w-1:-1:1
            % Scan zeilenweise von links oben nach rechts unten
            steigungx = (P(ii+1 , jj+1 ) + P(ii+1 , jj) + P(ii, jj +1 ) + P(ii, jj ) ) / 4 ;
            steigungy = (Q(ii+1 , jj+1 ) + Q(ii+1 , jj) + Q(ii, jj +1 ) + Q(ii, jj ) ) / 4 ;
            Z3(ii, jj ) = ( Z1(ii+1 , jj) + Z1(ii, jj +1 ) ) / 2 - ( steigungx + steigungy ) / 2 ;
        end
    end
    
   %% Top-right to Left-bottom  
    % SPezialfall erste SPalte fur jeden Scan
    for jj=w-1:-1:1
        % Scan zeilenweise von links oben nach rechts unten
        steigungx = (P(1,jj+1) + P(1,jj) ) / 2; 
        Z4(1, jj) = Z4(1, jj+1) - steigungx ;
    end
    % SPezialfall erste Zeile fur jeden Scan
    for ii=2:h 
        % Scan zeilenweise von links oben nach rechts unten
        steigungy = (Q(ii-1, w) + Q(ii, w) ) / 2; 
        Z4(ii, w) = Z4(ii-1, w) + steigungy ;
    end
    % Normalfall Punktiminneren fur jeden Scan
    for ii= 2:h
        for  jj = w-1:-1:1
            % Scan zeilenweise von links oben nach rechts unten
            steigungx = (P(ii-1 , jj+1 ) + P(ii , jj+1 ) + P(ii-1 , jj  ) + P(ii, jj ) ) / 4 ;
            steigungy = (Q(ii-1 , jj+1 ) + Q(ii , jj+1 ) + Q(ii-1 , jj  ) + Q(ii, jj ) ) / 4 ;
            Z4(ii, jj ) = ( Z4(ii , jj+1 ) + Z4(ii-1 , jj  ) ) / 2 -( steigungx - steigungy ) / 2 ;
        end
    end   

    %% combine 
    % Mittelung uber alle vier Scans
    Z = ( Z1 + Z2 + Z3 + Z4 ) / 4 ; 
    time=toc;
%     errP=Z(1:h,2:w)-Z(1:h,1:w-1)-0.5*(P(1:h,2:w)+P(1:h,1:w-1));
%     errP=errP.*errP;
%     errP=mean(mean(errP));
%     errQ=Z(2:h,1:w)-Z(1:h-1,1:w)-0.5*(Q(2:h,1:w)+Q(1:h-1,1:w));
%     errQ=errQ.*errQ;
%     errQ=mean(mean(errQ));
%     errPQ=errP+errQ;
    %errZ=sqrt(mean(mean((Z-Z).*(Z-Z))));
    disP=Z(1:h,2:w)-Z(1:h,1:w-1)-PP;
    disP=disP.*disP;
    errP=mean(mean(disP));
    disQ=Z(2:h,1:w)-Z(1:h-1,1:w)-QQ;
    disQ=disQ.*disQ;
    errQ=mean(mean(disQ));
    errPQ=sqrt(errP+errQ);
    infoOut={'time','errPQ';time,errPQ};
end

