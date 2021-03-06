package Bullwinkle::Client::FBP::Main;

## no critic

use 5.008005;
use utf8;
use strict;
use warnings;
use Wx 0.98 ':everything';

our $VERSION = '0.01';
our @ISA     = 'Wx::Frame';

sub new {
	my $class  = shift;
	my $parent = shift;

	my $self = $class->SUPER::new(
		$parent,
		-1,
		"Bullwinkle",
		wxDefaultPosition,
		wxDefaultSize,
		wxDEFAULT_FRAME_STYLE | wxTAB_TRAVERSAL,
	);
	$self->{status_bar} = $self->CreateStatusBar( 1, wxST_SIZEGRIP, -1 );

	$self->{client_perl} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		wxDefaultPosition,
		wxDefaultSize,
		wxTE_DONTWRAP | wxTE_MULTILINE,
	);
	$self->{client_perl}->SetMinSize( [ 200, 160 ] );
	$self->{client_perl}->SetToolTip(
		"client_perl"
	);

	$self->{client_json} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		wxDefaultPosition,
		wxDefaultSize,
		wxTE_DONTWRAP | wxTE_MULTILINE,
	);
	$self->{client_json}->SetMinSize( [ 200, 160 ] );
	$self->{client_json}->SetToolTip(
		"client_json"
	);

	$self->{encode} = Wx::Button->new(
		$self,
		-1,
		"Encode",
		wxDefaultPosition,
		wxDefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{encode},
		sub {
			shift->on_encode_clicked(@_);
		},
	);

	$self->{send} = Wx::Button->new(
		$self,
		-1,
		"Send",
		wxDefaultPosition,
		wxDefaultSize,
	);
	$self->{send}->Disable;

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{send},
		sub {
			shift->on_send_clicked(@_);
		},
	);

	$self->{server_json} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		wxDefaultPosition,
		wxDefaultSize,
		wxTE_DONTWRAP | wxTE_MULTILINE,
	);
	$self->{server_json}->SetMinSize( [ 200, 160 ] );
	$self->{server_json}->SetToolTip(
		"server_json"
	);

	$self->{server_perl} = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		wxDefaultPosition,
		wxDefaultSize,
		wxTE_DONTWRAP | wxTE_MULTILINE,
	);
	$self->{server_perl}->SetMinSize( [ 200, 160 ] );
	$self->{server_perl}->SetToolTip(
		"server_perl"
	);

	$self->{decode} = Wx::Button->new(
		$self,
		-1,
		"Decode",
		wxDefaultPosition,
		wxDefaultSize,
	);

	Wx::Event::EVT_BUTTON(
		$self,
		$self->{decode},
		sub {
			shift->on_decode_clicked(@_);
		},
	);

	$self->{server} = Wx::Menu->new;

	my $connect_to_server = Wx::MenuItem->new(
		$self->{server},
		-1,
		"Connect",
		"Connect to Bullwinkle Server",
		wxITEM_NORMAL,
	);

	Wx::Event::EVT_MENU(
		$self,
		$connect_to_server,
		sub {
			shift->connect_to_server(@_);
		},
	);

	my $disconnect_from_server = Wx::MenuItem->new(
		$self->{server},
		-1,
		"Disconnect",
		"Disconnect from Server",
		wxITEM_NORMAL,
	);

	Wx::Event::EVT_MENU(
		$self,
		$disconnect_from_server,
		sub {
			shift->disconnect_from_server(@_);
		},
	);

	my $status = Wx::MenuItem->new(
		$self->{server},
		-1,
		"Status",
		"Get Server Status",
		wxITEM_NORMAL,
	);

	Wx::Event::EVT_MENU(
		$self,
		$status,
		sub {
			shift->status(@_);
		},
	);

	my $quit = Wx::MenuItem->new(
		$self->{server},
		-1,
		"Quit",
		"Quit connection to Bullwinkle Server",
		wxITEM_NORMAL,
	);

	Wx::Event::EVT_MENU(
		$self,
		$quit,
		sub {
			shift->quit(@_);
		},
	);

	$self->{server}->Append( $connect_to_server );
	$self->{server}->Append( $disconnect_from_server );
	$self->{server}->AppendSeparator;
	$self->{server}->Append( $status );
	$self->{server}->AppendSeparator;
	$self->{server}->Append( $quit );

	$self->{m_menu3} = Wx::Menu->new;

	my $continue_null = Wx::MenuItem->new(
		$self->{m_menu3},
		-1,
		"Continue Simple",
		"Send Continue Merssage",
		wxITEM_NORMAL,
	);

	Wx::Event::EVT_MENU(
		$self,
		$continue_null,
		sub {
			shift->continue_null(@_);
		},
	);

	my $continue_function = Wx::MenuItem->new(
		$self->{m_menu3},
		-1,
		"Continue Function",
		"Send Message Continue to Function",
		wxITEM_NORMAL,
	);

	Wx::Event::EVT_MENU(
		$self,
		$continue_function,
		sub {
			shift->continue_function(@_);
		},
	);

	my $continue_line = Wx::MenuItem->new(
		$self->{m_menu3},
		-1,
		"Continue Line",
		"Send Message Continue to Line number",
		wxITEM_NORMAL,
	);

	Wx::Event::EVT_MENU(
		$self,
		$continue_line,
		sub {
			shift->continue_line(@_);
		},
	);

	my $continue_file = Wx::MenuItem->new(
		$self->{m_menu3},
		-1,
		"Continue File",
		"Send Message Continue to File and Line",
		wxITEM_NORMAL,
	);

	Wx::Event::EVT_MENU(
		$self,
		$continue_file,
		sub {
			shift->continue_file(@_);
		},
	);

	my $info_line = Wx::MenuItem->new(
		$self->{m_menu3},
		-1,
		"Info Line",
		'',
		wxITEM_NORMAL,
	);

	Wx::Event::EVT_MENU(
		$self,
		$info_line,
		sub {
			shift->info_line(@_);
		},
	);

	my $info_program = Wx::MenuItem->new(
		$self->{m_menu3},
		-1,
		"Info Program",
		'',
		wxITEM_NORMAL,
	);

	Wx::Event::EVT_MENU(
		$self,
		$info_program,
		sub {
			shift->info_program(@_);
		},
	);

	$self->{m_menu3}->Append( $continue_null );
	$self->{m_menu3}->Append( $continue_function );
	$self->{m_menu3}->Append( $continue_line );
	$self->{m_menu3}->Append( $continue_file );
	$self->{m_menu3}->Append( $info_line );
	$self->{m_menu3}->Append( $info_program );

	$self->{m_menubar2} = Wx::MenuBar->new(0);

	$self->{m_menubar2}->Append(
		$self->{server},
		"Server",
	);
	$self->{m_menubar2}->Append(
		$self->{m_menu3},
		"Comands",
	);

	$self->SetMenuBar( $self->{m_menubar2} );

	my $sbSizer1 = Wx::StaticBoxSizer->new(
		Wx::StaticBox->new(
			$self,
			-1,
			"Client",
		),
		wxHORIZONTAL,
	);
	$sbSizer1->Add( $self->{client_perl}, 1, wxALL | wxEXPAND, 5 );
	$sbSizer1->Add( $self->{client_json}, 1, wxALL | wxEXPAND, 5 );

	my $bSizer3 = Wx::BoxSizer->new(wxHORIZONTAL);
	$bSizer3->Add( 0, 0, 1, wxEXPAND, 5 );
	$bSizer3->Add( $self->{encode}, 0, wxALL, 5 );
	$bSizer3->Add( 0, 0, 1, wxEXPAND, 5 );
	$bSizer3->Add( $self->{send}, 0, wxALL, 5 );

	my $sbSizer2 = Wx::StaticBoxSizer->new(
		Wx::StaticBox->new(
			$self,
			-1,
			"Server",
		),
		wxHORIZONTAL,
	);
	$sbSizer2->Add( $self->{server_json}, 1, wxALL | wxEXPAND, 5 );
	$sbSizer2->Add( $self->{server_perl}, 1, wxALL | wxEXPAND, 5 );

	my $bSizer31 = Wx::BoxSizer->new(wxHORIZONTAL);
	$bSizer31->Add( 0, 0, 1, wxEXPAND, 5 );
	$bSizer31->Add( $self->{decode}, 0, wxALL, 5 );
	$bSizer31->Add( 0, 0, 1, wxEXPAND, 5 );

	my $bSizer2 = Wx::BoxSizer->new(wxVERTICAL);
	$bSizer2->Add( $sbSizer1, 1, wxALL | wxEXPAND, 5 );
	$bSizer2->Add( $bSizer3, 0, wxEXPAND, 5 );
	$bSizer2->Add( $sbSizer2, 1, wxALL | wxEXPAND, 5 );
	$bSizer2->Add( $bSizer31, 0, wxEXPAND, 5 );

	my $bSizer1 = Wx::BoxSizer->new(wxVERTICAL);
	$bSizer1->Add( $bSizer2, 1, wxEXPAND, 5 );

	$self->SetSizerAndFit($bSizer1);
	$self->Layout;

	return $self;
}

sub client_perl {
	$_[0]->{client_perl};
}

sub client_json {
	$_[0]->{client_json};
}

sub server_json {
	$_[0]->{server_json};
}

sub server_perl {
	$_[0]->{server_perl};
}

sub status_bar {
	$_[0]->{status_bar};
}

sub on_encode_clicked {
	warn 'Handler method on_encode_clicked for event encode.OnButtonClick not implemented';
}

sub on_send_clicked {
	warn 'Handler method on_send_clicked for event send.OnButtonClick not implemented';
}

sub on_decode_clicked {
	warn 'Handler method on_decode_clicked for event decode.OnButtonClick not implemented';
}

sub connect_to_server {
	warn 'Handler method connect_to_server for event connect_to_server.OnMenuSelection not implemented';
}

sub disconnect_from_server {
	warn 'Handler method disconnect_from_server for event disconnect_from_server.OnMenuSelection not implemented';
}

sub status {
	warn 'Handler method status for event status.OnMenuSelection not implemented';
}

sub quit {
	warn 'Handler method quit for event quit.OnMenuSelection not implemented';
}

sub continue_null {
	warn 'Handler method continue_null for event continue_null.OnMenuSelection not implemented';
}

sub continue_function {
	warn 'Handler method continue_function for event continue_function.OnMenuSelection not implemented';
}

sub continue_line {
	warn 'Handler method continue_line for event continue_line.OnMenuSelection not implemented';
}

sub continue_file {
	warn 'Handler method continue_file for event continue_file.OnMenuSelection not implemented';
}

sub info_line {
	warn 'Handler method info_line for event info_line.OnMenuSelection not implemented';
}

sub info_program {
	warn 'Handler method info_program for event info_program.OnMenuSelection not implemented';
}

1;
