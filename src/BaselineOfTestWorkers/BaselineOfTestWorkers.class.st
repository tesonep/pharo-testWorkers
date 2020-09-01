Class {
	#name : #BaselineOfTestWorkers,
	#superclass : #BaselineOf,
	#category : #BaselineOfTestWorkers
}

{ #category : #baselines }
BaselineOfTestWorkers >> baseline: spec [

	<baseline>

	spec
		for: #common
		do: [ 
	
			"Projects"
			spec 
				baseline: 'Stamp' 
				with: [ spec repository: 'github://tesonep/stamp' ].

			spec 
				baseline: 'OSSubprocess' 
				with: [ spec repository: 'github://pharo-contributions/OSSubprocess' ].

			"Packages"
			spec
				package: 'TestWorkers-Changes';
				package: 'TestWorkers-Connector' with: [ spec requires: #('Stamp') ];
				package: 'TestWorkers-Watchdog' 
					with: [ spec requires: #('OSSubprocess' 'TestWorkers-Connector') ];
				package: 'TestWorkers-Worker' with: [ spec requires: #('TestWorkers-Connector') ];
				package: 'TestWorkers-Client' with: [ spec requires: #('TestWorkers-Connector') ];
				package: 'TestWorkers-UI' with: [ spec requires: #('TestWorkers-Client') ];
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
