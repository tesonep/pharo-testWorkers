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

			"Packages"
			spec
				package: 'TestWorkers-Changes';
				package: 'TestWorkers-Changes-Tests' with: [ spec requires: 'TestWorkers-Changes' ].

			"Groups"
			spec
				group: 'core' with: #('TestWorkers-Changes');
				group: 'tests' with: #('TestWorkers-Changes-Tests');
				group: 'default' with: #(core tests) ]
]
