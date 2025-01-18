import { Inject, Injectable } from '@nestjs/common';
import { Model } from 'mongoose';
import { User } from './../core/domain/schemas/user.schema';
import { InjectModel } from '@nestjs/mongoose';
import { MD5 } from 'crypto-js';


@Injectable()
export class UsersService {

    constructor(
        @InjectModel(User.name) private  userRepository: Model<User>,
    ){}

    public async singup(data : any){
        //verify if email exists

        const user = await this.userRepository.findOne({email: data.email});

        if (user) return false;

        console.log(data);

        //hash passwd

        data.password = MD5(MD5(data.password).toString()).toString();

        const newUser = new this.userRepository(data);
        const mongoResponse = await newUser.save();
        console.log(mongoResponse);
        if (mongoResponse) return true;
        return false;
    }

    public async login(data : any){
        console.log(data);

        //hash passwd

        data.password = MD5(MD5(data.password).toString()).toString();

        const user = await this.userRepository.findOne({email: data.email, password: data.password});
        console.log(user);
        if (user) return true;
        return false;
    }


    public async modifyUser(data : any){
        const user = await this.userRepository.updateOne({email: data.email}, data);
        console.log(user);

        if (user) return true;
        return false;
    }
}