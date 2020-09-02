Class {
	#name : #RQExchange,
	#superclass : #RQEntity,
	#category : #'RabbitMQ-Rest'
}

{ #category : #configuration }
RQExchange >> deletePath [

	^ '/api/exchanges/{1}/{2}' format: { self vhost urlEncoded. self name urlEncoded }
]

{ #category : #configuration }
RQExchange >> savePath [

	^ '/api/exchanges/{1}/{2}' format: { self vhost urlEncoded. self name urlEncoded }
]

{ #category : #accessing }
RQExchange >> type [

	^ self dictionary at: #type
]

{ #category : #accessing }
RQExchange >> type: aValue [

	^ self dictionary at: #type put: aValue
]
