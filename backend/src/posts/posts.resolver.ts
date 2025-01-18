import { Resolver } from '@nestjs/graphql';
import { PostsService } from './posts.service';
import { Query } from '@nestjs/graphql';
import { RegisterUser} from './../core/domain/entities/auth.entity'

@Resolver()
export class PostsResolver {

    constructor(
        private postService: PostsService
    ){}


    @Query((returns) => [RegisterUser])
    posts(){
        return this.postService.findAll();
    }


    
}
