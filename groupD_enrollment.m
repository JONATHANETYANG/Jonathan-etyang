%creation of table
clc; clear;
T= table('Size',[0 9],'VariableTypes',{'string','string','double','string','string','string','string','string','string'},'VariableNames',{'NAME','TRIBE','AGE','INTERESTS','VILLAGE','DISTRICT','RELLIGION','COURSES','FACIAL_REPRESENTATION'});
%number of group members
n=input('How many members are you in your group: ');
for k=1:n

NAME=input('Enter name: ','s');
TRIBE=input('Enter tribe: ','s');
AGE=input('Enter age: ');
INTERESTS=input('Enter interests: ','s');
VILLAGE=input('Enter village: ','s');
DISTRICT=input('Enter home district: ','s');
RELLIGION=input('Enter relligion: ','s');
COURSES=input('Enter course offered: ','s');
FACIAL_REPRESENTATION=input('Enter facial representation: ','s');
%storing into table
T(k,:)={string(NAME),string(TRIBE),AGE,string(INTERESTS),string(VILLAGE),string(DISTRICT),string(RELLIGION),string(COURSES),string(FACIAL_REPRESENTATION)};
end
%showing final table
disp(T);










