function combine_strings_gui
    % Create the figure window
    f = figure('Name', 'String Combiner', 'Position', [500 500 300 200]);

    % First string input
    uicontrol('Style', 'text', 'Position', [30 150 80 20], 'String', 'First String:');
    str1 = uicontrol('Style', 'edit', 'Position', [120 150 140 25], 'String', '');

    % Second string input
    uicontrol('Style', 'text', 'Position', [30 110 80 20], 'String', 'Second String:');
    str2 = uicontrol('Style', 'edit', 'Position', [120 110 140 25], 'String', '');

    % Button to combine strings
    uicontrol('Style', 'pushbutton', 'Position', [100 70 100 30], ...
              'String', 'Combine', 'Callback', @combineCallback);

    % Result text
    result = uicontrol('Style', 'text', 'Position', [30 30 240 25], 'String', '', ...
                       'FontWeight', 'bold');

    % Callback function
    function combineCallback(~, ~)
        s1 = get(str1, 'String');
        s2 = get(str2, 'String');
        combined = [s1, ' ', s2];
        set(result, 'String', combined);
    end
end
