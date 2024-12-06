% File which helps saving results to the proper place

% Get datetime

function [day, time] = getDateTime()

    date_time = datetime("now");

    time = string(timeofday(date_time));
    date_time.Format = "dd-MMM-yyyy";

    day = string(date_time);

end
