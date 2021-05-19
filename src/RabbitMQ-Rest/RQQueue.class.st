Class {
	#name : #RQQueue,
	#superclass : #RQEntity,
	#category : #'RabbitMQ-Rest'
}

{ #category : #configuration }
RQQueue >> deletePath [

	^ '/api/queues/{1}/{2}' format: { self vhost urlEncoded. self name urlEncoded }
]

{ #category : #accessing }
RQQueue >> messages [
	
	^ dictionary at: #messages
]

{ #category : #configuration }
RQQueue >> purge [

	^ server newRequest
		delete: ('/api/queues/{1}/{2}/contents' format: { self vhost urlEncoded. self name urlEncoded })
]

{ #category : #configuration }
RQQueue >> savePath [

	^ '/api/queues/{1}/{2}' format: { self vhost urlEncoded. self name urlEncoded }
]
