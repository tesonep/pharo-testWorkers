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
				package: 'TestWorkers-Changes-Tests' with: [ spec requires: 'TestWorkers-Changes' ];
				package: 'TestWorkers-Runner' with: [ spec requires: #('Stamp' 'OSSubprocess') ].

			"Groups"
			spec
				group: 'core' with: #('TestWorkers-Changes');
				group: 'tests' with: #('TestWorkers-Changes-Tests');
				group: 'runner' with: #('TestWorkers-Runner' core);
				group: 'default' with: #(core tests) ]
]
