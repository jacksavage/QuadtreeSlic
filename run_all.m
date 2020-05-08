img_names = [
    %"Adirondack"
%     "ArtL"
%     "Jadeplant"
%     "Motorcycle"
%     "MotorcycleE"
    "Piano"
    "PianoL"
    "Pipes"
    "Playroom"
    "Playtable"
    "PlaytableP"
    "Recycle"
    "Shelves"
    "Teddy"
    "Vintage"
];

K = [2000];

for i = 1:length(img_names)
    img_name = img_names(i);
    
    for j = 1:length(K)
        k = K(j);
        
        quad_tree_slic(img_name,k);
    end
end
