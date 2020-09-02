Class {
	#name : #RQQueue,
	#superclass : #RQEntity,
	#category : #'RabbitMQ-Rest'
}

{ #category : #configuration }
RQQueue >> deletePath [

	^ '/api/queues/{1}/{2}' format: { self vhost urlEncoded. self name urlEncoded }
]

{ #category : #configuration }
RQQueue >> savePath [

	^ '/api/queues/{1}/{2}' format: { self vhost urlEncoded. self name urlEncoded }
]
