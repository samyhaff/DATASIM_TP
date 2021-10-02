function [morceau,t] = genere_morceau(freq_notes, duree,fe)

% freq_notes : veteur contenant les frequences des notes
% duree : vecteur contenant la duree de chaque note
% fe : frequence d'echantillonnage

morceau = [];

for ii=1:length(freq_notes), 
    t = 0:1/fe:duree(ii);
    morceau = [morceau ; sin(2*pi*freq_notes(ii)*t)'];
end

N = length(morceau);
t = (0:N-1)/fe;

% normalisation
morceau = morceau/max(abs(morceau));




