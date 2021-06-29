Class {
	#name : #BaselineOfTestWorkers,
	#superclass : #BaselineOf,
	#category : #BaselineOfTestWorkers
}

{ #category : #baselines }
BaselineOfTestWorkers >> baseline: spec [

	<baseline>

	| subprocess |
	spec
		for: #common
		do: [ 
	
			"Projects"
			spec 
				baseline: 'Stamp' 
				with: [ spec repository: 'github://tesonep/stamp' ].

			Smalltalk platform isWindows 
				ifTrue: [
					spec
						baseline: 'OSWinSubprocess' 
						with: [ spec repository: 'github://pharo-contributions/OSWinSubprocess' ].
					subprocess := 'OSWinSubprocess' ] 
				ifFalse: [			
					spec 
						baseline: 'OSSubprocess' 
						with: [ spec repository: 'github://pharo-contributions/OSSubprocess' ].
					subprocess := 'OSSubprocess'].

			"Other Packages"
			spec
				package: 'RabbitMQ-Rest'.

			"Packages"
			spec
				package: 'TestWorkers-Changes';
				package: 'TestWorkers-Connector' with: [ spec requires: #('Stamp') ];
				package: 'TestWorkers-Watchdog' 
					with: [ spec requires: { subprocess. 'TestWorkers-Connector'. 'RabbitMQ-Rest' } ];
				package: 'TestWorkers-Worker' with: [ spec requires: #('TestWorkers-Connector') ];
				package: 'TestWorkers-Client' with: [ spec requires: #('TestWorkers-Connector') ];
				package: 'TestWorkers-UI' with: [ spec requires: #('TestWorkers-Client') ];
				package: 'TestWorkers-Connector-Tests' with: [ spec requires: #('TestWorkers-Connector') ];
				package: 'TestWorkers-Changes-Tests' with: [ spec requires: 'TestWorkers-Changes' ].

			"Groups"
			spec
				group: 'changes' with: #('TestWorkers-Changes');
				group: 'tests' with: #('TestWorkers-Changes-Tests');
				group: 'worker' with: #('TestWorkers-Worker');
				group: 'client' with: #('TestWorkers-Client');
				group: 'watchdog' with: #('TestWorkers-Watchdog');	
				group: 'ui' with: #('TestWorkers-UI');				
				group: 'default' with: #(changes tests worker client watchdog ui) ]
]
