%%%%% ѭ���׼��OFDM�ź� %%%%% 
clear;
clc;
close all;

%%% OFDM���� %%%
%���ݳ��ȵ�1/8������ڵ���ѭ���ײ�������
%�������� 6-BPSK, 12-QPSK
%%%%%%%%%%%%%%%%
TXVECTOR.LENGTH = 256; % ���ݳ���
TXVECTOR.DATARATE = 6; % ��������
%trst_rate = 20e6; % �źŷ�������,�㶨
trst_rate = 1; % �źŷ������� normlized
%fc = 100e6;
fc = 2; % normlized

%%% ѭ���׼����� %%%
%������Ϊ -fs/2 �� fs/2
%ѭ��Ƶ�ʷֱ���Ϊ fs/N
%Ƶ�ʷֱ���Ϊ M*fs/N
%%%%%%%%%%%%%%%%%%%%%
%fs = 300e6; % ����Ƶ��
fs = 4; % ����Ƶ�� normlized
N = 2048; % ��������
M = 20; % ƽ������

%%% �ŵ����� %%%
SNR = 15; % �����

%{ PSK
%%% ����������� %%%
PSDU = round(rand(1,8*TXVECTOR.LENGTH));
%%% OFDM�ź����� %%%
sig = transmitter(PSDU,TXVECTOR);
ref_sig = sig;
%}

data  = randi([0 3],N,1);
sig = qammod(data,4)/sqrt(2); 
sig = sig';

%{
%%% �����źŲ����� %%%
s_n = ceil(fs/trst_rate); % �������ʽ���ΪOFDM�ź����ʵ�������
sig = sig(ones(s_n,1),:); % ��Ԫ����
sig = reshape(sig, 1, s_n*length(sig));
%}
sig = interp(sig, round(fs/fc)); %upsample

%%% �ز����� %%%
sig_chnl = real(sig.*exp(sqrt(-1)*2*pi*fc/fs*(0:length(sig)-1)));


%%% ��˹�ŵ� %%%
sig_awgn = awgn(sig_chnl, SNR);
%sig_awgn = awgn(zeros(1,N), SNR);

%%% ѭ���׼�� %%%
cyclic_spectrum(sig_awgn, N, fs, M);
