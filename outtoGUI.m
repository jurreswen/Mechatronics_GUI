function[] = outtoGUI(txt)
%Outputs the text to the GUI or if the GUI is closed it outputs it to the
%MATLAB Command Window

c=clock;

text = [int2str(c(4)),':',sprintf('%02.0f',c(5)),' ',txt];
listbox = findobj('tag','text_out');
if listbox.Value == 1
    prevtxt = get(findobj('tag','text_out'),'String');
    set(findobj('tag','text_out'),'String',char(text,prevtxt))
else
disp(text)
%set(findobj('tag','text_out'),'String',text)
end



