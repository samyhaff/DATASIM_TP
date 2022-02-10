function validation(data, modid)
    present(modid)
    [y,RT2] = compare(modid, data);
    fprintf('RT2 : %f\n', RT2)
    resid(data,modid);
end