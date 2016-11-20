# ActionJob example

In this example ActionJob is used to start a job on server start.
More information about ActionJob can be found in the [Rails Documentation](http://edgeguides.rubyonrails.org/active_job_basics.html).

## Prerequisites

In this example we start from an new Rails project. You can create a project just by running the `rails new my-actionjob-app`.

## Adding ActionJob to your project

You can simply add a job to your application by using the _job generator_. In this example our job is called `awesome`.

```bash
rails generate job awesome
```

The generator will create some file for you. A `awesome_job.rb` file in the `app/jobs` directory, and a `awesome_job_test.rb` file in the `test/jobs` directory.

```bash
invoke  test_unit
create    test/jobs/awesome_job_test.rb
create  app/jobs/awesome_job.rb
```

## Do some work inside your new job

The genrator created the `app/jobs/awesome_job.rb` file. In this file you can place the code to be executed in the job. By default a `perform` method is provided. We can change the implementation of this method.

Generated `app/jobs/awesome_job.rb` file:
```Ruby
class AwesomeJob < ApplicationJob
    queue_as :default

    def perform(*args)
        # Do something later
    end
end
```

In this example we will do some endless work inside a loop. The loop will send some text to the console, and wait for 5 seconds to do this all over again.

You can replace the implemenation with what ever you want. eg:
* Creating new models, an save them to the database.
* Listen to an external service
* ...

```Ruby
def perform(*args)
    loop do
        puts "Hello from my awesome job"
        sleep 5
    end
end
```

## Executing the job

The job can be executed anywhere inside the Rails application. In our case we want to start the job at server startup. To achieve this, we need to create a new initializer. This is easy, just add a new file to the `config/initializers` directory.

Lets create new file `config/initializers/awesome_job.rb`

To execute our task we need to wait until Rails is done with all the configuration. We can do this by placing our code inside a `Rails.application.config.after_initialize` block.

Starting (or rather queueing) the job can be done by simply calling the `perform_later` method on the `AwesomeJob` class. Note that we need to add the `_later` postfix to our defined method. This behavior is added by the `ActionJob` class. It merely suggest that the task will be executed when the job is ready to be queued. In our case the job will be executed immediately.

```ruby
Rails.application.config.after_initialize do
    AwesomeJob.perform_later
end
```

## Remarks

The code is now started `after_initialize`. This event also occures when rails tasks are executed (like `rails db:migrate`). The implementation can be improved. But at the moment it gets the job done.
