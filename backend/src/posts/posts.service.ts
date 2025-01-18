import { Injectable } from '@nestjs/common';
import { RegisterUser } from './../core/domain/entities/auth.entity';
import { User } from 'src/core/domain/schemas/user.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

@Injectable()
export class PostsService {
    constructor(
        @InjectModel(User.name) private userModel: Model<User>
    ){}
    findAll() {
        return this.userModel.find().exec();
        //return this.userModel.find().exec();
        // return[{
        //     name: 'John Doe',
        //     email: 'jpndoe@mail.com',
        //     password: '123456',
        //     phone: '1234567890'
        // }]
    }
}
