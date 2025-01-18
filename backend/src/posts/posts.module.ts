import { Module } from '@nestjs/common';
import { PostsService } from './posts.service';
import { PostsResolver } from './posts.resolver';
import { User, UserSchema } from './../core/domain/schemas/user.schema';
import { Mongoose } from 'mongoose';
import { MongooseModule } from '@nestjs/mongoose';

@Module({
  providers: [PostsService, PostsResolver],
  imports : [
    MongooseModule.forFeature([
      { name: 'User', schema: UserSchema }
    ])
  ]
})
export class PostsModule {}
